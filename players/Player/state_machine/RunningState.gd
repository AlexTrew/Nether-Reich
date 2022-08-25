extends "res://utils/AbstractFSMState.gd"


const speed = 10
const acceleration = 1
const deceleration = 1

var ray_origin = Vector3()
var ray_target = Vector3()
var camera	

var movement_started

var dodge_ready

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
	fsm_owner.get_node("LegsSpriteHolder").get_node("AnimatedSpriteLegs").play(move_animation)
	movement_started = false
	fsm_owner.get_node("PlayerTranslationComponent").set_params(speed, acceleration, deceleration)
	fsm_owner.get_node("Pike").visible = false
	if !fsm_owner.lantern_in_right_hand:
		fsm_owner.get_node("HeldWeaponSprite").visible = true



func transit():
	if fsm_owner.can_control:

		if Input.is_action_just_pressed("shift"):
			fsm_owner.get_node("Pike").visible = false
			fsm_owner.get_node("HeldWeaponSprite").visible = false
			fsm_owner.stop_footstep_sound()
			return 'blocking'
		if Input.is_action_just_pressed("ctrl"):
			Logger.log(self, fsm_owner.get_left_hand_item())
			if(fsm_owner.get_left_hand_item() != 'nothing'):
				fsm_owner.get_node("Pike").visible = false
				fsm_owner.get_node("HeldWeaponSprite").visible = false
				fsm_owner.stop_footstep_sound()
				return 'using_left_hand_item'
			else:
				pass

func state_process(_delta):

	walk_sfx()

	if fsm_owner.motion.length() > 1 && fsm_owner.get_node("LegsSpriteHolder").get_node("AnimatedSpriteLegs").animation == "idle":
		fsm_owner.get_node("LegsSpriteHolder").get_node("AnimatedSpriteLegs").animation = move_animation
	elif fsm_owner.motion.length() < 1:
		fsm_owner.get_node("LegsSpriteHolder").get_node("AnimatedSpriteLegs").animation = "idle"

	if fsm_owner.can_control:
		fsm_owner.get_node("PlayerRotationComponent").look_at_cursor()

		if Input.is_action_just_pressed("left_click"):
			self.fsm_owner.melee_attack()

		elif Input.is_action_just_pressed("space"):
			if fsm_owner.dodge_ready:
				fsm_owner.dodge_ready = false
				self.fsm_owner.sidestep()
		
		elif Input.is_action_just_pressed("1"):
			fsm_owner.use_ability(1)
		elif Input.is_action_just_pressed("2"):
			fsm_owner.use_ability(2)
		elif Input.is_action_just_pressed("3"):
			fsm_owner.use_ability(3)
		elif Input.is_action_just_pressed("4"):
			fsm_owner.use_ability(4)


func walk_sfx():
	if !movement_started && fsm_owner.motion.length() > 0.5:
		fsm_owner.play_footstep_sound("running")
		movement_started = true
	elif fsm_owner.motion.length() < 0.5:
		fsm_owner.stop_footstep_sound()
		movement_started = false


func state_physics_process(_delta):
	if fsm_owner.can_control:
		fsm_owner.get_node("PlayerTranslationComponent").movement()

func _on_DodgeTimer_timeout():
	fsm_owner.dodge_ready = true


# put all this is LegsSpriteHolder, make move_animation a variable there. set it from the states
func _on_receive_move_right_legs_animation_signal():
	move_animation = "move_side_right"

func _on_receive_reverse_legs_animation_signal(reverse):
	if reverse:
		move_animation = "move_backwards"
	else:
		move_animation = "move"

func _on_receive_move_left_legs_animation_signal():
	move_animation = "move_side_left"


