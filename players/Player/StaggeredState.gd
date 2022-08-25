extends "res://utils/AbstractFSMState.gd"


const speed = 3
const acceleration = 0.5
const deceleration = 1

var ray_origin = Vector3()
var ray_target = Vector3()
var camera

var staggered_end 


func _ready():
	staggered_end = false;
	$StaggeredTimer.connect("timeout", self, "_on_StaggeredTimer_timeout")



func on_transition_to():
	staggered_end = false
	$StaggeredTimer.start()
	fsm_owner.get_node("PlayerTranslationComponent").set_params(speed, acceleration, deceleration)
	fsm_owner.get_node("Pike").visible = false

func transit():
	if staggered_end:
		return "running"


func state_process(_delta):

	pass

func state_physics_process(_delta):
	fsm_owner.get_node("PlayerTranslationComponent").movement()

func _on_StaggeredTimer_timeout():
	staggered_end = true
