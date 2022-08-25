extends "res://utils/AbstractFSMState.gd"


const speed = 3
const acceleration = 0.5
const deceleration = 1

var transition_done

var ray_origin = Vector3()
var ray_target = Vector3()
var camera

func _ready():
	pass

func on_transition_to():
	fsm_owner.get_node("PlayerTranslationComponent").set_params(speed, acceleration, deceleration)
	camera = fsm_owner.get_parent().get_node("Camera")
	var _c = get_parent().get_node("MovementTypeTransitionTimer").connect("timeout", self, "_on_movement_type_transition_timer_timeout")
	transition_done = false
	get_parent().get_node("MovementTypeTransitionTimer").start()

func transit():
	if(transition_done):
		if Input.is_action_pressed("space"):
			if(fsm_owner.get_node("Rifle").get_node("RifleFSM").get_current_state_index() == 'loading_round_shot' or fsm_owner.get_node("Rifle").get_node("RifleFSM").get_current_state_index() == 'loading_canister_shot'):
				return 'reloading'
			else:
				return 'using_left_hand_item'
		else:
			return 'running'

func state_process(_delta):
	fsm_owner.get_node("PlayerRotationComponent").look_at_cursor()


func state_physics_process(_delta):
	fsm_owner.get_node("PlayerTranslationComponent").movement()


func _on_movement_type_transition_timer_timeout():
	transition_done = true
