extends "res://utils/AbstractFSMState.gd"


const DECELERATION = 200000
var recovered = false


func _ready():
	var __ = $StunnedTimer.connect("timeout", self, "_on_stunned_timer_timeout")

func on_transition_to():
	recovered = false
	$StunnedTimer.start()

func transit():
	var new_state

	# ADVANCING transition function
	if recovered:
		fsm_owner.get_node("AnimatedSprite").flip_v = false
		new_state = 'ADVANCING'

	return new_state

func state_physics_process(_delta):
	fsm_owner.motion = Vector3(0,0,0)

func state_process(_delta):
	pass


func take_hit(value, piercing):
	fsm_owner.take_damage(value, piercing)
	hit = true
		

func _on_stunned_timer_timeout():
	recovered = true




	






