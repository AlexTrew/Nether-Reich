
extends "res://utils/AbstractFSMState.gd"

# maximum speed in pixels/s 
const SPEED = 10

# acceleration in pixels/s^2
const ACCELERATION = 1000

var recoil_complete = false


func _ready():
	var _c = $RecoilingTimer.connect("timeout", self, "_on_RecoilingTimer_timeout")


func on_transition_to():
	if randi() % 2 != 0:
		fsm_owner.get_node("AnimatedSprite").flip_v = true
	recoil_complete = false
	$RecoilingTimer.start()


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
	
	fsm_owner.motion = (fsm_owner.motion + (recoil_direction * ACCELERATION))
	if self.fsm_owner.motion.length() > SPEED:
		self.fsm_owner.motion = self.fsm_owner.motion.normalized() * SPEED


func take_hit(value, piercing):
	fsm_owner.take_damage(value, piercing)
	hit = true
		
	
func _on_RecoilingTimer_timeout():
	recoil_complete = true
