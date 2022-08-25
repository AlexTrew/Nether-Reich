extends "res://utils/AbstractFSMState.gd"


const DECELERATION = 500
var recovered = false


func _ready():
	var __ = $StunnedTimer.connect("timeout", self, "_on_stunned_timer_timeout")

func on_transition_to():
	fsm_owner.get_node("AnimatedSpriteLegs").animation = "still"
	fsm_owner.play_footstep_sound(null)
	recovered = false
	$StunnedTimer.start()

func transit():
	var new_state

	# ADVANCING transition function
	if recovered:
		new_state = 'SIDESTEP'

	return new_state

func set_aggressiveness_mod(value):
	pass

func state_physics_process(_delta):
	fsm_owner.motion = decelerate(fsm_owner.motion, _delta)

func state_process(_delta):
	pass


func take_hit(value, piercing):
	fsm_owner.take_damage(value, piercing)


func decelerate(motion, delta):
	if motion.x > 0:
		motion.x = max(0, motion.x - DECELERATION * delta)

	elif motion.x < 0:
		motion.x = min(0, motion.x + DECELERATION * delta)

	if motion.y < 0:
		motion.y = min(0, motion.y + DECELERATION * delta)

	elif motion.y > 0:
		motion.y = max(0, motion.y - DECELERATION * delta)

	return motion

func _on_stunned_timer_timeout():
	recovered = true




	






