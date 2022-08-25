extends "res://utils/AbstractFSMState.gd"


const SPEED = 0


func state_physics_process(_delta):
	fsm_owner.motion = Vector3(0, 0, 0)

func state_process(_delta):
	pass


func transit():
	pass

func set_aggressiveness_mod(value):
	pass

func on_transition_to():
	fsm_owner.get_node("AnimatedSpriteLegs").animation = "still"
	fsm_owner.play_footstep_sound(null)

func take_hit(value, piercing):
	pass
