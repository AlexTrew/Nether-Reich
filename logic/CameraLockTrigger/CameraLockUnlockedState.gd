extends "res://utils/AbstractFSMState.gd"


var transition_over = false


func _ready():
	fsm_owner = self.get_parent().get_parent()

func state_process(_delta):
		fsm_owner.global_transform.origin.x = fsm_owner.target.global_transform.origin.x
		fsm_owner.global_transform.origin.z = fsm_owner.target.global_transform.origin.z


func on_transition_to():
	pass	

func transit():
	pass

