extends "res://utils/AbstractFSMState.gd"


# maxumum speed in pixels/s 
const SPEED = 1

# acceleration in pixels/s^2
const ACCELERATION = 100

const ROTATION_RATE = 6

var charge_done = false
var ready_to_attack = false
var once = false
var aggressiveness_mod = 0

func _ready():
	var _c = $FaintAttackTimer.connect("timeout", self, "_on_FaintAttackTimer_timeout")
	var _d = $DamageDelayTimer.connect("timeout", self, "_on_DamageDelayTimer_timeout")

func state_physics_process(_delta):
	var direction = -((fsm_owner.global_transform.origin - fsm_owner.target.global_transform.origin).normalized())
	
	# work out the speed to add this tick (acceleration)
	# note that delta is not used - this motion vector is passed to move_and_slide which will apply delta
	var motion = direction * ACCELERATION
	fsm_owner.motion = (fsm_owner.motion + motion)

	if self.fsm_owner.motion.length() > SPEED:
		self.fsm_owner.motion = self.fsm_owner.motion.normalized() * SPEED
	
func state_process(_delta):
	fsm_owner.transform = fsm_owner.transform.interpolate_with(
		fsm_owner.transform.looking_at(fsm_owner.target.transform.origin, Vector3.UP),
		 ROTATION_RATE * _delta
		) 

func transit():
	var new_state

	if hit:
		new_state = 'DEFENDING'

	#i have a bad feeling about this
	elif !once && !ready_to_attack && get_parent().is_at_attacking_distance():
		once = true
		$DamageDelayTimer.start()

	elif ready_to_attack && get_parent().is_at_attacking_distance():
		new_state = 'ATTACKING'

	# ADVANCING transition function 
	elif charge_done && !get_parent().is_at_flanking_distance():
		new_state = 'ADVANCING'

	elif charge_done:
		new_state = 'ADVANCING'

	return new_state

func set_aggressiveness_mod(value):
	aggressiveness_mod = value

func take_hit(value, piercing):
	hit = true


func _on_FaintAttackTimer_timeout():
	charge_done = true

func _on_DamageDelayTimer_timeout():
	ready_to_attack = true

func on_transition_to():
	fsm_owner.get_node("AnimatedSpriteLegs").animation = "lunge"
	hit = false
	fsm_owner.play_footstep_sound("running")
	once = false
	ready_to_attack = false
	charge_done = false
	$FaintAttackTimer.start()



