extends "res://utils/AbstractFSMState.gd"

func _ready():
	fsm_owner = fsm_owner.get_parent()

func on_transition_to():
	pass

func transit():
	pass

func state_process(_delta):
	pass

func state_physics_process(_delta):
	pass
