extends "res://utils/AbstractFSMState.gd"


# maxumum speed in pixels/s 
const SPEED = 20

# acceleration in pixels/s^2
const ACCELERATION = 400

var charge_complete
var temp_target
var direction

func _ready():
	$ChargingTimer.connect("timeout", self, "_on_charging_timer_timeout")

func state_physics_process(_delta):
	
	# work out the speed to add this tick (acceleration)
	# note that delta is not used - this motion vector is passed to move_and_slide which will apply delta
	var motion = direction * ACCELERATION
	fsm_owner.motion = (fsm_owner.motion + motion)

	if self.fsm_owner.motion.length() > SPEED:
		self.fsm_owner.motion = self.fsm_owner.motion.normalized() * SPEED
	

func state_process(_delta):
	pass


func transit():
	var new_state

	if hit:
		new_state = 'RECOILING'
		fsm_owner.get_node("AnimatedSprite").get_node("Eyes").visible = false
	elif charge_complete || get_parent().is_at_attacking_distance():
		new_state = 'ATTACKING'

	# ADVANCING transition function 
	#elif !get_parent().is_at_flanking_distance():
	#	new_state = 'ADVANCING'

	return new_state


func take_hit(value, piercing):
	fsm_owner.take_damage(value, piercing)
	hit = true

	
func on_transition_to():
	fsm_owner.get_node("AnimatedSprite").get_node("Eyes").animation = "charging"
	fsm_owner.play_attack_sound()
	temp_target = fsm_owner.target
	fsm_owner.look_at(temp_target.global_transform.origin, Vector3.UP)
	direction = -(fsm_owner.global_transform.origin - temp_target.global_transform.origin)
	hit = false
	charge_complete = false
	$ChargingTimer.start()

func _on_charging_timer_timeout():
	charge_complete = true
#add charge timer
