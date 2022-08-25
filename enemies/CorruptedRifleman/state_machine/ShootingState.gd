extends "res://utils/AbstractFSMState.gd"


# maximum speed in pixels/s 
const SPEED = 0

# acceleration in pixels/s^2
const ACCELERATION = 0

var fired


func state_physics_process(_delta):
	# do not move while aiming
	fsm_owner.motion = Vector3(0, 0, 0)

func state_process(_delta):
	if !fired:
		fsm_owner.attack()
		fired = true


func take_hit(value, piercing):
	fsm_owner.take_damage(value, piercing)
	hit = true


func transit():
	var new_state

	if hit:
		new_state = 'RECOILING'
	# POST_SHOOTING transition function 
	if fired:
		new_state = 'POST_SHOOTING'

	return new_state

func on_transition_to():
	hit = false
	fired = false


