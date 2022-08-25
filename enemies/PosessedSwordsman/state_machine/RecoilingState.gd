extends "res://utils/AbstractFSMState.gd"

# maximum speed in pixels/s 
const SPEED = 1

# acceleration in pixels/s^2
const ACCELERATION = 1000

var recoil_complete = false


func _ready():
	var _c = $RecoilingTimer.connect("timeout", self, "_on_RecoilingTimer_timeout")

func on_transition_to():
	fsm_owner.play_footstep_sound("running")
	recoil_complete = false
	$RecoilingTimer.start()

func transit():
	var new_state

	# STUNNED transition function:
	if recoil_complete:
		new_state = 'STUNNED'

	return new_state

func set_aggressiveness_mod(value):
	pass


func take_hit(value, piercing):
	hit = true
	fsm_owner.take_damage(value, piercing)


func state_process(_delta):
	pass

func state_physics_process(_delta):
	# todo: this should be based on damage direction, not player location
	var recoil_direction = (fsm_owner.transform.origin - fsm_owner.target.transform.origin).normalized()
	
	fsm_owner.motion = (fsm_owner.motion + (recoil_direction * ACCELERATION))
	if self.fsm_owner.motion.length() > SPEED:
		self.fsm_owner.motion = self.fsm_owner.motion.normalized() * SPEED

	
	
func _on_RecoilingTimer_timeout():
	recoil_complete = true
