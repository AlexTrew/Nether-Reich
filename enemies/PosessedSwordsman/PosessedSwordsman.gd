extends "res://enemies/AbstractEnemy/AbstractEnemy.gd"

var base_aggressiveness = 6 #placeholder inital value; initialise this upon spawing enemy

var player_pistol_drawn_aggression_mod = 10

var sounds


func _init():
	defense = 1
	attack_damage = 8
	health = 25
	state_to_animation = {
		'IDLE': 'idle',
		'ADVANCING': 'open',
		'FLANKING': 'open',
		'FLANKINGBLOCKING': 'ready',
		'CHARGING': 'charge',
		'ATTACKING': 'attack',
		'FAINTATTACKING': 'attack',
		'PREATTACKING': 'telegraph',
		'RECOILING': 'stunned',
		'DEFENDING': 'defend',
		'STUNNED': 'stunned',
		'SIDESTEP' : 'ready',
		'ATTACKRECOVER': 'open',
		'DEAD': 'dead'
	}

	sounds = {
		"walking": preload("res://enemies/PosessedSwordsman/assets/Netherreich_Footstep_Walking_Concrete.wav"),
		"running": preload("res://enemies/PosessedSwordsman/assets/Netherreich_Footstep_Running_Grass_1.wav"),
		"sprinting": preload("res://enemies/PosessedSwordsman/assets/Netherreich_Footstep_Sprinting_Grass_1.wav"),
		"stab_impact": preload("res://common/assets/sounds/stab.wav")
	}


func _ready():
	
	set_drop_component($DropItemComponent)
	var _connection = $ObservePlayerTimer.connect("timeout", self, "_on_ObservePlayerTimer_timeout")
	$StateMachine.set_state('ADVANCING')

	connect_animated_sprite_signals()
	

func attack():
	for body in $AttackArea.get_overlapping_bodies():
		if body.is_in_group("player"):
			body.take_damage(attack_damage, attack_damage)

func take_hit(value, piercing):
	if health > 0:
		$StateMachine.current_state.take_hit(value, piercing)
	if(health <= 0):
		die()

func take_damage(value, piercing):
	damage_sprite_modulate()
	$DamageAudioStreamPlayer3D.play()
	health -= value
	.send_modify_health_signal(health)

func modify_aggressiveness(value):
	$StateMachine.set_aggressiveness_mod(value)

func take_parry():
	if(get_current_state() == 'CHARGING'):
		$StateMachine.set_state("RECOILING")

#do this again
func take_block():
	# bad
	if(get_current_state() == 'CHARGING'):
		$BlockedSwordClankAudioStreamPlayer.pitch_scale = (randf()) + 0.2
		$BlockedSwordClankAudioStreamPlayer.play()
		$StateMachine.set_state("DEFENDING")

func _on_ObservePlayerTimer_timeout():
	if !(target and target.is_in_group('player')):
		Logger.log(self, "Lost track of the player.")

	if (target.get_node("PlayerFSM").get_current_state_index() == "walking"):
		modify_aggressiveness(player_pistol_drawn_aggression_mod)
	else:
		modify_aggressiveness(0)

func play_footstep_sound(sound_id):
	if sound_id:
		$FootstepsAudioStreamPlayer2D.stream = self.sounds[sound_id]
		$FootstepsAudioStreamPlayer2D.play()
	else:
		$FootstepsAudioStreamPlayer2D.stop()

func play_damage_sound(sound_id):
	if sound_id:
		$DamageAudioStreamPlayer3D.stream = self.sounds[sound_id]
		$DamageAudioStreamPlayer3D.play()
	else:
		$DamageAudioStreamPlayer3D.stop()

func play_attack_sound():
	$AttackAudioStreamPlayer3D.pitch_scale = (randf()/2) + 0.8
	$AttackAudioStreamPlayer3D.play()


func play_block_attack_sound():
	$BlockingSwordClankAudioStreamPlayer.pitch_scale = randf() + 0.2
	$BlockingSwordClankAudioStreamPlayer.play()


func die():
	.die()
	$DeathAudioStreamPlayer3D.pitch_scale = rand_range(1.0, 1.3)
	$DeathAudioStreamPlayer3D.play()


func connect_animated_sprite_signals():
	var _a = $AnimatedSprite.connect("animation_finished", self, "_on_death_animation_finished")

func _on_death_animation_finished():
	if !corpse_darkened && $AnimatedSprite.animation == "dead":
		corpse_darkened = true
		darken_sprite()

func darken_sprite():
	$Tween.connect("tween_all_completed", self, "_darken_tween_finished")
	$Tween.interpolate_property(get_node("AnimatedSprite"), "modulate", Color(1,1,1,1), Color(0.5,0.5,0.5,1), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	$Tween.start()

func _darken_tween_finished():
	$Tween.remove_all()
