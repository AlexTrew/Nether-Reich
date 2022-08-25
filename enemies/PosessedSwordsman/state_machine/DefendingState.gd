extends "res://utils/AbstractFSMState.gd"

# maximum speed in pixels/s 
const SPEED = 3

# acceleration in pixels/s^2
const ACCELERATION = 1000

const ROTATION_RATE = 6

var recoil_complete = false


func _ready():
	var _c = $DefendingTimer.connect("timeout", self, "_on_DefendingTimer_timeout")

func on_transition_to():
	fsm_owner.get_node("AnimatedSpriteLegs").animation = "lunge"
	fsm_owner.play_block_attack_sound()
	fsm_owner.play_footstep_sound("walking")
	recoil_complete = false
	$DefendingTimer.start()

func transit():
	var new_state

	# FLANKING transition function:
	
	if recoil_complete:
		if randf() > 0.7:
			new_state = 'FLANKINGBLOCKING'
		else:
			new_state = 'FLANKING'

	return new_state

func set_aggressiveness_mod(value):
	pass

func state_process(_delta):
	# fsm_owner.transform = fsm_owner.transform.interpolate_with(
	# 	fsm_owner.transform.looking_at(fsm_owner.target.global_transform.origin, Vector3.UP),
	# 	 ROTATION_RATE * _delta
	# 	) 
	fsm_owner.look_at(fsm_owner.target.global_transform.origin, Vector3.UP)

func state_physics_process(_delta):
	# todo: this should be based on damage direction, not player location
	var recoil_direction = (fsm_owner.global_transform.origin - fsm_owner.target.global_transform.origin).normalized()
		
	if self.fsm_owner.motion.length() > SPEED:
		self.fsm_owner.motion = (self.fsm_owner.motion + (recoil_direction * ACCELERATION)).normalized() * SPEED
	
	return self.fsm_owner.move_and_slide_2d(self.fsm_owner.motion)


func take_hit(value, piercing):
	pass


func _on_DefendingTimer_timeout():
	recoil_complete = true
