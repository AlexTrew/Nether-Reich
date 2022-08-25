extends "res://utils/AbstractFSMState.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var preattack_complete

# Called when the node enters the scene tree for the first time.
func _ready():
	var __ = $TelegraphTimer.connect("timeout", self, "_on_TelegraphTimer_timeout")

func set_aggressiveness_mod(mod):
	pass

func state_process(_delta):
	fsm_owner.motion = Vector3(0, 0, 0)

func state_physics_process(_delta):
	pass 

func on_transition_to():
	fsm_owner.get_node("SwordSlideAudioStreamPlayer3D").pitch_scale = rand_range(0.9, 1.1)
	fsm_owner.get_node("SwordSlideAudioStreamPlayer3D").play()
	fsm_owner.get_node("AnimatedSpriteGlint").visible = true
	fsm_owner.get_node("AnimatedSpriteGlint").frame = 0
	fsm_owner.get_node("AnimatedSpriteGlint").play()
	fsm_owner.get_node("AnimatedSpriteLegs").animation = "still"
	hit = false
	fsm_owner.play_footstep_sound(null)
	preattack_complete = false
	$TelegraphTimer.start()

func transit():
	var new_state 
	if hit:
		fsm_owner.get_node("AnimatedSpriteGlint").visible = false
		fsm_owner.get_node("AnimatedSpriteGlint").stop()
		new_state = 'RECOILING'
	
	elif preattack_complete:
		fsm_owner.get_node("AnimatedSpriteGlint").visible = false
		fsm_owner.get_node("AnimatedSpriteGlint").stop()
		new_state = 'CHARGING'
	
	return new_state


func take_hit(value, piercing):
	hit = true
	fsm_owner.take_damage(value, piercing)


func _on_TelegraphTimer_timeout():
	preattack_complete = true