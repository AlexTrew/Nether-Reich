extends "res://utils/AbstractFSMState.gd"

# maximum speed in pixels/s 
const SPEED = 150

# acceleration in pixels/s^2
const ACCELERATION = 1000

var recoil_complete = false


func _ready():
	$RecoilingTimer.connect("timeout", self, "_on_RecoilingTimer_timeout")


func on_transition_to():
	self.recoil_complete = false
	$RecoilingTimer.start(0.1)


func transit():
	var new_state

	# STUNNED transition function:
	if recoil_complete:
		new_state = 'STUNNED'

	return new_state

func state_process(_delta):
	pass

func state_physics_process(_delta):
	# todo: this should be based on damage direction, not player location
	var recoil_direction = (fsm_owner.global_transform.origin - fsm_owner.target.global_transform.origin).normalized()
	
	#fsm_owner.motion = (fsm_owner.motion + (recoil_direction * ACCELERATION)).clamped(SPEED)

	
func take_hit(value, piercing):
	hit = true
	fsm_owner.take_damage(value, piercing)


func _on_RecoilingTimer_timeout():
	self.recoil_complete = true

