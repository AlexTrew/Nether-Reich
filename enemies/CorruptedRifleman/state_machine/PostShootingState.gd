extends "res://utils/AbstractFSMState.gd"


# maximum speed in pixels/s 
const SPEED = 0

# acceleration in pixels/s^2
const ACCELERATION = 0

var waited
var wait_time = 1


func _ready():
	$PostShootingTimer.connect("timeout", self, "_on_PostShootingTimer_timeout")

func state_physics_process(delta):
	fsm_owner.motion = Vector3(0, 0, 0)

func state_process(_delta):
	pass


func take_hit(value, piercing):
	hit = true
	fsm_owner.take_damage(value, piercing)


func transit():
	var new_state

	if hit:
		new_state = 'RECOILING'
	# ADVANCING transition function 
	if waited:
		new_state = 'ADVANCING'

	return new_state

func on_transition_to():
	hit = false
	waited = false

	$PostShootingTimer.start(wait_time)

func _on_PostShootingTimer_timeout():
	waited = true

