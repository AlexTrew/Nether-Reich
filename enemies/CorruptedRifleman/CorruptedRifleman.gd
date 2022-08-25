extends "res://enemies/AbstractEnemy/AbstractEnemy.gd"


var bullet_scene = preload("res://enemies/CorruptedRifleman/CorruptedRiflemanRoundShot.tscn")
var smoke_effect_scene = preload("res://effects/MusketSmokeEffect.tscn")
var looking_at

var sounds = {
	"stab_impact": preload("res://common/assets/sounds/stab.wav")
}

func _init():
	health = 20
	defense = 80

	state_to_animation = {
		'IDLE': 'idle',
		'ADVANCING': 'idle', 
		'SHOOTING': 'aim', 
		'POST_SHOOTING': 'aim', 
		'AIMING': 'aim', 
		'RECOILING': 'idle', 
		'STUNNED': 'idle', 
		'DEAD': 'dead', 
	}

func _ready():
	._ready()
	
	set_drop_component($DropItemComponent)
	$FlashTimer.connect("timeout", self, "_on_FlashTimer_timeout")

	connect_animated_sprite_signals()

func attack():


	$FireAudioStreamPlayer2D.pitch_scale = rand_range(0.8, 1.2)
	$FireAudioStreamPlayer2D.play()

	var smoke_effect =  smoke_effect_scene.instance() 
	self.get_parent().add_child(smoke_effect)
	smoke_effect.global_transform.origin = self.global_transform.origin + Vector3(0,1,0)


	var bullet = bullet_scene.instance()
	self.get_parent().add_child(bullet)
	bullet.global_transform.origin = self.global_transform.origin 
	bullet.init(self, looking_at.normalized())

func take_hit(value, piercing):
	if health > 0:
		$StateMachine.current_state.take_hit(value, piercing)


func damage_sprite_modulate():
	$DamageSpriteModulateTimer.start()
	$SpriteHolder/AnimatedSprite.modulate = "ff0000"
	$SpriteHolder/AnimatedSprite.shaded = false

func take_damage(value, piercing):
	damage_sprite_modulate()
	self.play_damage_sound("stab_impact")
	health -= value
	Logger.log(self, "took %s damage, my health is %s" % [value, health])
	.send_modify_health_signal(health)

	if health <= 0:
		die()

func _on_FlashTimer_timeout():
	$Flash.visible = false


func _on_damage_modulate_timer_timeout():
	$SpriteHolder/AnimatedSprite.modulate = "ffffff"
	$SpriteHolder/AnimatedSprite.shaded = true


func connect_animated_sprite_signals():
	var _a = $SpriteHolder/AnimatedSprite.connect("animation_finished", self, "_on_death_animation_finished")


func _on_death_animation_finished():
	if !corpse_darkened && $SpriteHolder/AnimatedSprite.animation == "dead":
		corpse_darkened = true
		darken_sprite()

func darken_sprite():
	$Tween.connect("tween_all_completed", self, "_darken_tween_finished")
	$Tween.interpolate_property($SpriteHolder/AnimatedSprite, "modulate", Color(1,1,1,1), Color(0.5,0.5,0.5,1), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	$Tween.start()

func _darken_tween_finished():
	$Tween.remove_all()
