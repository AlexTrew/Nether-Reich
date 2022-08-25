extends "res://utils/AbstractFSMState.gd"


const speed = 3
const acceleration = 0.5
const deceleration = 1

var transition_done

var ray_origin = Vector3()
var ray_target = Vector3()
var camera

func _ready():
	fsm_owner = fsm_owner.get_parent().get_parent()

func on_transition_to():
	fsm_owner.get_node("LanternTimer").start()
	fsm_owner.get_node("PlayerTranslationComponent").set_params(speed, acceleration, deceleration)
	var _c = get_parent().get_node("GunDrawTimer").connect("timeout", self, "_on_movement_type_transition_timer_timeout")
	transition_done = false
	get_parent().get_node("GunDrawTimer").start()


func transit():
	if(transition_done):
		return 'done'


func state_process(_delta):
	fsm_owner.get_node("PlayerRotationComponent").look_at_cursor()


func state_physics_process(_delta):
	fsm_owner.get_node("PlayerTranslationComponent").movement()


func _on_movement_type_transition_timer_timeout():
	transition_done = true