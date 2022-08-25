extends "res://utils/AbstractFSMState.gd"


const walk_speed = 4
const walk_acceleration = 100
const walk_deceleration = 100

var initial_lunge_speed = 30
var lunge_speed = initial_lunge_speed
const lunge_acceleration = 100

const time_for_lunge = 0.15

const min_lunge_velocity = 0

var attack_ready = false
var lunge_direction
var lunge

var camera

signal lunging

var move_animation

func _ready():
	$LungeAndAttackTimer.connect("timeout", self, "_on_lunge_and_attack_timer_timeout")
	$StepBeforeAttackTimer.connect("timeout", self, "_step_before_attack_timer")
	$StepSlowdownWindowTimer.connect("timeout", self, "_on_step_slowdown_window_timer_timetout")
	connect("lunging", fsm_owner.get_parent().get_parent().get_node("Camera"), "_on_player_lunging_signal_received")

func on_transition_to():

	hamper_step_after_attack()

	fsm_owner.get_node("LegsSpriteHolder").get_node("AnimatedSpriteLegs").animation = "lunge"
	fsm_owner.get_node("HeldWeaponSprite").visible = false
	self.fsm_owner.get_node("Pike/AttackAudioStreamPlayer3D").pitch_scale = (randf()/2) + 2.5
	self.fsm_owner.get_node("Pike/AttackAudioStreamPlayer3D").play()
	fsm_owner.get_node("Pike").visible = true
	emit_signal("lunging")
	attack_ready = false
	lunge_direction = fsm_owner.get_direction_to_mouse()

	self.fsm_owner.get_node("AnimatedSprite").get_sprite_frames().set_animation_speed('stab', 30 )
	lunge = true
	$LungeAndAttackTimer.set_wait_time(time_for_lunge)
	$StepBeforeAttackTimer.start()
	
	$LungeAndAttackTimer.start()


func hamper_step_after_attack():
	if $StepSlowdownWindowTimer.is_stopped():
		$StepSlowdownWindowTimer.start()


func transit():
	if attack_ready:
		if Input.is_action_pressed("shift"):
			return 'blocking'
		else:
			return 'running'

func state_process(_delta):
	
	if(lunge && len(fsm_owner.get_node("Pike").get_node("AttackArea").get_overlapping_bodies()) > 0):
		$StepBeforeAttackTimer.stop()
		self.fsm_owner.get_node("Pike").attack()
		lunge = false

func state_physics_process(_delta):
	if(lunge):
		self.fsm_owner.motion.x += lunge_direction.x * lunge_acceleration
		self.fsm_owner.motion.z += lunge_direction.z * lunge_acceleration
		if self.fsm_owner.motion.length() > lunge_speed:
			self.fsm_owner.motion = self.fsm_owner.motion.normalized() * lunge_speed

	else:
		if self.fsm_owner.motion.length() > walk_speed:
			self.fsm_owner.motion = self.fsm_owner.motion.normalized() * walk_speed

	return self.fsm_owner.move_and_slide_2d(self.fsm_owner.motion)

func _on_lunge_and_attack_timer_timeout():
	attack_ready = true
	lunge_speed = lunge_speed / 2

func _on_step_slowdown_window_timer_timetout():
	lunge_speed = initial_lunge_speed


func _step_before_attack_timer():
	self.fsm_owner.get_node("Pike").get_node("AnimationPlayer").play('stab')
	lunge = false
