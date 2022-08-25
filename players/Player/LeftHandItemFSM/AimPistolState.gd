extends "res://utils/AbstractFSMState.gd"


const speed = 3
const acceleration = 0.5
const deceleration = 1

var ray_origin = Vector3()
var ray_target = Vector3()
var camera

var fired

func _ready():
	fsm_owner = fsm_owner.get_parent().get_parent()


func on_transition_to():
	if fsm_owner.lantern_in_right_hand:
		fsm_owner.lantern_instance = fsm_owner.drop_lantern()
	fsm_owner.get_node('Rifle').get_node("RifleClickAudioStreamPlayer").play()
	fsm_owner.get_node("PlayerTranslationComponent").set_params(speed, acceleration, deceleration)
	fired = false


func transit():
	if fired:
		get_parent().get_parent().set_animation('holster_pistol')
		return 'holster_pistol'


func state_process(_delta):
	fsm_owner.get_node("PlayerRotationComponent").look_at_cursor()

	if Input.is_action_just_released("ctrl"):
		fsm_owner.get_node('Rifle').shoot(fsm_owner, -(fsm_owner.global_transform.basis.z))
		fired = true


func state_physics_process(_delta):
	fsm_owner.get_node("PlayerTranslationComponent").movement()
