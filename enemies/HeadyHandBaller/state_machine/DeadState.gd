extends "res://utils/AbstractFSMState.gd"


const SPEED = 0


func state_physics_process(_delta):
	fsm_owner.motion = Vector3(0, 0, 0)

func transit():
	pass

func state_process(_delta):
	pass

func on_transition_to():
	fsm_owner.set_physics_process(false)
	fsm_owner.global_transform.origin.y = rand_range(0.05, 0.3)



func take_hit(value, piercing):
	pass


func _physics_process(delta):
	pass
