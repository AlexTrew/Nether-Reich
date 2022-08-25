extends "res://utils/AbstractFSMState.gd"


var y_lock
var x_lock

var transition_over = false


# Called when the node enters the scene tree for the first time.
func _ready():
	fsm_owner = self.get_parent().get_parent()

func state_process(_delta):
	if transition_over:
		if(fsm_owner.global_transform.origin.x != x_lock):
			fsm_owner.global_transform.origin.x = x_lock
		fsm_owner.global_transform.origin.y = 1
		fsm_owner.global_transform.origin.z = fsm_owner.target.global_transform.origin.z
	else:
		if(fsm_owner.global_transform.origin.x == x_lock):
			transition_over = true
		fsm_owner.global_transform.origin.x = lerp(fsm_owner.global_transform.origin.x , x_lock, _delta*10)
		fsm_owner.global_transform.origin.z = lerp(fsm_owner.global_transform.origin.z , fsm_owner.target.global_transform.origin.z, _delta*10)

func set_lock_coords(coord):
	x_lock = coord.x

func on_transition_to():
	transition_over = false
	self.x_lock = self.fsm_owner.x_lock

func transit():
	pass

