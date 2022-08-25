extends "res://enemies/AbstractEnemy/AbstractEnemy.gd"


var fat_man_animated_sprite = preload("res://enemies/CorruptedVillager/VilliagerAnimiatedSprites/AnimatedSpriteFatMan.tscn")
var creepy_man_animated_sprite = preload("res://enemies/CorruptedVillager/VilliagerAnimiatedSprites/AnimatedSpriteCreepy.tscn")
var mole_woman_animated_sprite = preload("res://enemies/CorruptedVillager/VilliagerAnimiatedSprites/AnimatedSpriteMoleWoman.tscn")


var animated_sprites = [creepy_man_animated_sprite, fat_man_animated_sprite, mole_woman_animated_sprite]


var sounds = {
	"stab_impact": preload("res://common/assets/sounds/stab.wav")
}

func _init():
	health = 15
	attack_damage = 3
	defense = 80

	state_to_animation = {
		'IDLE': 'idle',
		'ADVANCING': 'move',
		'FLANKING': 'move',
		'CHARGING': 'charge',
		'ATTACKING': 'attack',
		'RECOILING': 'idle',
		'STUNNED': 'idle',
		'DEAD': 'dead',
		'PREATTACKING' : 'preattack'
	}

func _ready():
	randomize()
	var random_index = randi() % len(animated_sprites)
	var animated_sprite = animated_sprites[random_index].instance()
	add_child(animated_sprite)
	animated_sprite.name = "AnimatedSprite"

	connect_animated_sprite_signals()

	$AmbientAudioDelayTimer.connect("timeout", self, "_on_ambient_audio_delay_timer_timeout")

	set_drop_component($DropItemComponent)
	play_ambient_sound_loop_after_delay()

	$StateMachine.set_state('ADVANCING')
	
func play_ambient_sound_loop_after_delay():
	var random_delay = rand_range(0,3)
	$AmbientAudioDelayTimer.wait_time = random_delay
	$AmbientAudioDelayTimer.start()


func take_block():
	if(get_current_state() == 'CHARGING'):
		$StateMachine.set_state("RECOILING")

func take_damage(value, piercing):
	damage_sprite_modulate()
	self.play_damage_sound("stab_impact")
	health -= value
	.send_modify_health_signal(health)
	
	Logger.log(self, "took %s damage, my health is %s" % [value, health])
	if health <= 0:
		die()

func take_hit(value, piercing):
	if health > 0:
		$StateMachine.current_state.take_hit(value, piercing)


func attack():
	for body in $AttackArea.get_overlapping_bodies():
		if body.is_in_group("player"):
			body.take_damage(attack_damage, attack_damage)


func play_attack_sound():
	$AttackAudioStreamPlayer3D.pitch_scale = (randf()/2) + 0.8
	$AttackAudioStreamPlayer3D.play()


func die():
	$AnimatedSprite/Eyes.visible = false
	$AnimatedSprite/AmbientAudioStreamPlayer3D.stop()
	$AnimatedSprite/DeathSoundAudioStreamPlayer3D.pitch_scale = rand_range(0.9,1.1)
	$AnimatedSprite/DeathSoundAudioStreamPlayer3D.play()
	.die()


func _on_ambient_audio_delay_timer_timeout():
	$AnimatedSprite/AmbientAudioStreamPlayer3D.play()


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