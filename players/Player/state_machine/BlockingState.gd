extends "res://utils/AbstractFSMState.gd"


const speed = 5
const acceleration = 0.5
const deceleration = 1

var ray_origin = Vector3()
var ray_target = Vector3()
var camera

var movement_started 
 
var move_animation


func _ready():

	fsm_owner.get_node("LegsSpriteHolder").connect("play_reverse_legs_animation", self, "_on_receive_reverse_legs_animation_signal")
	fsm_owner.get_node("LegsSpriteHolder").connect("play_move_right_legs_animation", self, "_on_receive_move_right_legs_animation_signal")
	fsm_owner.get_node("LegsSpriteHolder").connect("play_move_left_legs_animation", self, "_on_receive_move_left_legs_animation_signal")
	$DodgeTimer.connect("timeout", self, "_on_DodgeTimer_timeout")
	fsm_owner.dodge_ready = true


func on_transition_to():
	fsm_owner.get_node("LegsSpriteHolder").get_node("AnimatedSpriteLegs").flip_h = true
	move_animation = "move"
	movement_started = false
	fsm_owner.get_node("PlayerTranslationComponent").set_params(speed, acceleration, deceleration)
	fsm_owner.get_node("Pike").visible = true
	if fsm_owner.lantern_in_right_hand:
		fsm_owner.lantern_instance = fsm_owner.drop_lantern()
	fsm_owner.get_node("LanternTimer").stop()
	fsm_owner.blocking = true
	fsm_owner.get_node("HeldWeaponSprite").visible = false

func transit():
	if Input.is_action_just_released("shift"):
		fsm_owner.blocking = false
		fsm_owner.get_node("LanternTimer").start()
		return 'running'
	if Input.is_action_just_pressed("ctrl"):
		fsm_owner.blocking = false
		Logger.log(self, fsm_owner.get_left_hand_item())
		if(fsm_owner.get_left_hand_item() != 'nothing'):
			fsm_owner.get_node("Pike").visible = false
			return 'using_left_hand_item'
		else:
			pass

func state_process(_delta):

	if fsm_owner.motion.length() > 1 && fsm_owner.get_node("LegsSpriteHolder").get_node("AnimatedSpriteLegs").animation == "idle":
		fsm_owner.get_node("LegsSpriteHolder").get_node("AnimatedSpriteLegs").animation = move_animation
	elif fsm_owner.motion.length() < 1:
		fsm_owner.get_node("LegsSpriteHolder").get_node("AnimatedSpriteLegs").animation = "idle"

		
	walk_sfx()
	fsm_owner.get_node("PlayerRotationComponent").look_at_cursor()

	if Input.is_action_just_pressed("left_click"):
		self.fsm_owner.melee_attack()

	elif Input.is_action_just_pressed("right_click"):
		if fsm_owner.dodge_ready:
			fsm_owner.dodge_ready = false
			self.fsm_owner.sidestep()

	else:
		fsm_owner.block()

func walk_sfx():
	if !movement_started && fsm_owner.motion.length() > 0.5:
		fsm_owner.play_footstep_sound("walking")
		movement_started = true
	elif fsm_owner.motion.length() < 0.5:
		fsm_owner.stop_footstep_sound()
		movement_started = false

func state_physics_process(_delta):
	fsm_owner.get_node("PlayerTranslationComponent").movement()


func is_leg_animation_changed(animation):
	return animation != move_animation


func _on_DodgeTimer_timeout():
	fsm_owner.dodge_ready = true

func _on_receive_move_right_legs_animation_signal():
	move_animation = "move_side_right"

func _on_receive_reverse_legs_animation_signal(reverse):
	if reverse:
		move_animation = "move_backwards"
	else:
		move_animation = "move"

func _on_receive_move_left_legs_animation_signal():
	move_animation = "move_side_left"
