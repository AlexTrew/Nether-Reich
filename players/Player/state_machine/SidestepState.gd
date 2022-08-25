extends "res://utils/AbstractFSMState.gd"


var camera
var sidestep_direction
var sidestep_complete

const sidestep_speed = 30
const sidestep_acceleration = 70

signal sidestepping

var dust_effect_scene = preload("res://effects/SidestepDustEffect.tscn")

func _ready():
	$SidestepTimer.connect("timeout", self, "_on_SidestepTimer_timeout")
	$DustSpaceTimer.connect("timeout", self, "_on_DustSpaceTimer_timeout")
	connect("sidestepping", fsm_owner.get_parent().get_parent().get_node("Camera"), "_on_player_sidestepping_signal_received")

func on_transition_to():
	fsm_owner.get_node("LegsSpriteHolder").get_node("AnimatedSpriteLegs").animation = "lunge"
	emit_signal("sidestepping")
	fsm_owner.invulnerable = true
	sidestep_complete = false

	sidestep_direction = fsm_owner.motion.normalized()

	self.fsm_owner.get_node("AnimatedSprite").get_sprite_frames().set_animation_speed('stab', 30 )
	$SidestepTimer.start(0.1)
	if fsm_owner.motion.length() >= 1:
		fsm_owner.get_node("SidestepStreamPlayer3D").pitch_scale = rand_range(1.50, 1.8)
		fsm_owner.get_node("SidestepStreamPlayer3D").play()
		kick_up_dust_effect()
		$DustSpaceTimer.start()


func transit():
	if sidestep_complete:
		$DustSpaceTimer.stop()
		self.get_parent().get_node('RunningState').get_node('DodgeTimer').start()
		fsm_owner.invulnerable = false
		if Input.is_action_pressed("shift"):
			return 'blocking'
		else:
			return 'running'


func state_physics_process(_delta):

	self.fsm_owner.motion.x += sidestep_direction.x * sidestep_acceleration
	self.fsm_owner.motion.z += sidestep_direction.z * sidestep_acceleration
	if self.fsm_owner.motion.length() > sidestep_speed:
		self.fsm_owner.motion = self.fsm_owner.motion.normalized() * sidestep_speed

	return self.fsm_owner.move_and_slide_2d(self.fsm_owner.motion)


func state_process(_delta):
	pass

	
func _on_SidestepTimer_timeout():
	sidestep_complete = true

func _on_DustSpaceTimer_timeout():
	kick_up_dust_effect()

func kick_up_dust_effect():
	var dust_instance = dust_effect_scene.instance()
	fsm_owner.get_parent().add_child(dust_instance)
	dust_instance.global_transform.origin = Vector3(fsm_owner.global_transform.origin.x, 0.2, fsm_owner.global_transform.origin.z)
