extends "res://utils/AbstractFSMState.gd"

var y_lock
var z_lock

var transition_over = false

# Called when the node enters the scene tree for the first time.
func _ready():
	fsm_owner = self.get_parent().get_parent()



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func state_process(_delta):
	if transition_over:
		if(fsm_owner.global_transform.origin.z != z_lock):
			fsm_owner.global_transform.origin.z = z_lock
		fsm_owner.global_transform.origin.y = 1
		fsm_owner.global_transform.origin.x = fsm_owner.target.global_transform.origin.x
	else:
		if(fsm_owner.global_transform.origin.z == z_lock):
			transition_over = true
		fsm_owner.global_transform.origin.z = lerp(fsm_owner.global_transform.origin.z, z_lock, _delta*10)
		fsm_owner.global_transform.origin.x = lerp(fsm_owner.global_transform.origin.x , fsm_owner.target.global_transform.origin.x, _delta*10)

func set_lock_coords(coord):
	z_lock = coord.z


func on_transition_to():
	transition_over = false
	self.z_lock = self.fsm_owner.z_lock

func transit():
	pass
