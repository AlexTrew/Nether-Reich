extends "res://utils/AbstractFSMState.gd"


const SPEED = 0


func state_process(_delta):
	pass

func state_physics_process(_delta):
	fsm_owner.motion = Vector3(0, 0, 0)

func transit():
	pass

func on_transition_to():
	pass
