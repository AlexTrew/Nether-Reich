extends "res://enemies/AbstractEnemy/AbstractEnemy.gd"

var sounds = {
	"stab_impact": preload("res://common/assets/sounds/stab.wav"),
	"vomit" : preload("res://enemies/HeadyHandBaller/Sounds/vom1.ogg"),
	"vomit_1" : preload("res://enemies/HeadyHandBaller/Sounds/vom2.ogg")
}

func _init():
	health = 30
	attack_damage = 1
	defense = 80

	state_to_animation = {
		'IDLE': 'idle',
		'ROAMING' : 'roaming',
		'STILL'	: 'idle',
		'ATTACKING': 'roaming',
		'RECOILING': 'idle',
		'STUNNED': 'idle',
		'DEAD': 'dead'
	}

func _ready():
	set_drop_component($DropItemComponent)
	$StateMachine.set_state('ROAMING')

	connect_animated_sprite_signals()

func take_damage(value, piercing):
	damage_sprite_modulate()
	$DamageAudioStreamPlayer3D.play()
	health -= value
	.send_modify_health_signal(health)
	Logger.log(self, "took %s damage, my health is %s" % [value, health])
	if health <= 0:
		die()

func take_hit(value, piercing):
	if health > 0:
		$StateMachine.current_state.take_hit(value, piercing)


func damage_sprite_modulate():
	$DamageSpriteModulateTimer.start()
	$AnimatedSprite.modulate = "ff0000"
	$AnimatedSprite.shaded = false
	$SpriteHolder/AnimatedSprite.modulate = "ff0000"
	$SpriteHolder/AnimatedSprite.shaded = false


func attack():
	for body in $AttackArea.get_overlapping_bodies():
		if body.is_in_group("player"):
			body.take_damage(attack_damage, attack_damage)

func play_vomit_sound():
	randomize()
	if randi() % 2 == 0:
		$VomitAudioStreamPlayer3D.stream = sounds["vomit"]
	else:
		$VomitAudioStreamPlayer3D.stream = sounds["vomit_1"]
	$VomitAudioStreamPlayer3D.play()


func die():
	get_node("MovementAudioStreamPlayer3D").stop()
	blood_spray_spawn()
	.emit_signal("dead")
	#drop_item_component.drop_pickup("powder", 3)
	drop_item_component.drop_pickup("energy")
	drop_item_component.random_drop_pickup()

	if $StateMachine.get_current_state_index() != 'DEAD':
		$StateMachine.set_state("DEAD")

		if(get_node_or_null('AnimatedSprite')):
			$AnimatedSprite.flip_v = randi() % 2
		if get_node_or_null('SpriteHolder'):
			$SpriteHolder.get_node("AnimatedSprite").flip_v = randi() % 2
			$SpriteHolder.get_node("AnimatedSprite").animation = "dead"

		$CollisionShape.call_deferred("free")
		Logger.log(self, "dead")


func _on_damage_modulate_timer_timeout():
	$AnimatedSprite.modulate = "ffffff"
	$AnimatedSprite.shaded = true
	$SpriteHolder/AnimatedSprite.modulate = "ffffff"
	$SpriteHolder/AnimatedSprite.shaded = true



func connect_animated_sprite_signals():
	var _a = $AnimatedSprite.connect("animation_finished", self, "_on_death_animation_finished")


func _on_death_animation_finished():
	if !corpse_darkened && $AnimatedSprite.animation == "dead":
		corpse_darkened = true
		darken_sprite()

func darken_sprite():
	$Tween.connect("tween_all_completed", self, "_darken_tween_finished")
	$Tween.interpolate_property($SpriteHolder/AnimatedSprite, "modulate", Color(1,1,1,1), Color(0.5,0.5,0.5,1), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	$Tween.interpolate_property($AnimatedSprite, "modulate", Color(1,1,1,1), Color(0.5,0.5,0.5,1), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	$Tween.start()

func _darken_tween_finished():
	$Tween.remove_all()