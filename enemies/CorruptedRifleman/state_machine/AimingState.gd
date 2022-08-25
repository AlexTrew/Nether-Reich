extends "res://utils/AbstractFSMState.gd"


# maximum speed in pixels/s 
const SPEED = 0

# acceleration in pixels/s^2
const ACCELERATION = 0

var aimed
var aim_time = 0.5


func _ready():
	$AimingTimer.connect("timeout", self, "_on_AimingTimer_timeout")
	$FlashDelayTimer.connect("timeout", self, "_on_flash_delay_timer_timeout")

func state_physics_process(_delta):
	# do not move while aiming
	fsm_owner.motion = Vector3(0, 0, 0)

func state_process(delta):
	pass
	
func transit():
	var new_state

	if hit:
		new_state = 'RECOILING'
	elif self.aimed:
		new_state = 'SHOOTING'

	return new_state


func take_hit(value, piercing):
	hit = true
	fsm_owner.take_damage(value, piercing)
	

func on_transition_to():
	aimed = false
	$FlashDelayTimer.start()
	fsm_owner.looking_at = fsm_owner.target.global_transform.origin - fsm_owner.global_transform.origin

	$AimingTimer.start(aim_time)

func _on_AimingTimer_timeout():
	aimed = true


func _on_flash_delay_timer_timeout():
	fsm_owner.get_node("FlashTimer").start();
	fsm_owner.get_node("Flash").visible = true
	fsm_owner.get_node("ClickAudioStream").play()
