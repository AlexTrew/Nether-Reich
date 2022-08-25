extends "res://utils/AbstractFSMState.gd"
# maximum speed in pixels/s 
const SPEED = 9

# acceleration in pixels/s^2
const ACCELERATION = 1000
const ROTATION_RATE = 8
var sidestep_complete = false


func _ready():
	var _c = $SidestepTimer.connect("timeout", self, "_on_RecoilingTimer_timeout")

func on_transition_to():
	fsm_owner.play_footstep_sound("running")
	randomize()
	sidestep_complete = false
	$SidestepTimer.start()

func transit():
	var new_state

	# STUNNED transition function:
	if sidestep_complete:
		if randf() > 0.7:
			new_state = 'FLANKINGBLOCKING'
		else:
			new_state = 'FLANKING'

	return new_state

func set_aggressiveness_mod(value):
	pass


func take_hit(value, piercing):
	if piercing > fsm_owner.defense:
		fsm_owner.take_damage(value, piercing)
		fsm_owner.injured = true

	
func state_process(_delta):
	if fsm_owner.target:
		fsm_owner.transform = fsm_owner.transform.interpolate_with(
			fsm_owner.transform.looking_at(fsm_owner.target.transform.origin, Vector3.UP),
			ROTATION_RATE * _delta
			) 

func state_physics_process(_delta):
	# todo: this should be based on damage direction, not player location
	var recoil_direction = (fsm_owner.global_transform.origin - fsm_owner.target.global_transform.origin).normalized()
	
	fsm_owner.motion = (fsm_owner.motion + (recoil_direction * ACCELERATION))
	if self.fsm_owner.motion.length() > SPEED:
		self.fsm_owner.motion = self.fsm_owner.motion.normalized() * SPEED

	
	
func _on_RecoilingTimer_timeout():
	sidestep_complete = true
