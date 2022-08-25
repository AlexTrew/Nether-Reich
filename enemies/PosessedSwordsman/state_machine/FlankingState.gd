extends "res://utils/AbstractFSMState.gd"


var flank_complete
var flank_right
var faint

var tangent2 = Vector2(0,0)
var tangent3 = Vector3(0,0,0)

const SPEED_MIN = 2
const SPEED_MAX = 10

var speed

# acceleration in pixels/s^2
const ACCELERATION = 75

const ROTATION_RATE = 6

var faint_rate = 0.3
var aggressiveness = 8
var aggressiveness_mod = 0
const attack_suppression_factor = 10
const min_cooldown = 0.2


func _ready():
	var _connection = $FlankingTimer.connect("timeout", self, "_on_Timer_timeout")

func on_transition_to():
	speed = rand_range(SPEED_MIN, SPEED_MAX)
	fsm_owner.get_node("AnimatedSpriteLegs").animation = "flank"
	hit = false
	fsm_owner.play_footstep_sound("walking")
	flank_complete = false
	flank_right = randi() % 2
	faint = randf()
	var ftime = min_cooldown + (randf()* attack_suppression_factor) / aggressiveness + aggressiveness_mod
	$FlankingTimer.start(ftime)

func transit():
	var new_state

	if hit:
		new_state = 'RECOILING'
	# ADVANCING transition function:
	elif get_parent().has_left_flanking_distance():
		new_state = 'ADVANCING'
	
	# CHARGING transition function
	elif flank_complete:
		if faint < faint_rate:
			new_state = 'FAINTATTACKING'
		elif get_parent().is_at_charging_distance():
			new_state = 'PREATTACKING'
		else:
			new_state = 'ADVANCING'

	return new_state

	
func state_physics_process(_delta):
	var forward = (fsm_owner.global_transform.origin - fsm_owner.target.global_transform.origin)
	var tangent = fsm_owner.get_node("Plane2DMovementHelper").get_2d_tangent(forward, flank_right)

	# work out the speed to add this tick (acceleration)
	# note that delta is not used - this motion vector is passed to move_and_slide which will apply delta
	var motion = tangent * ACCELERATION
	fsm_owner.motion = fsm_owner.motion + motion

	if(fsm_owner.motion.length() > speed):
		fsm_owner.motion = fsm_owner.motion.normalized() * speed


func set_aggressiveness_mod(value):
	aggressiveness_mod = value

func state_process(_delta):
	fsm_owner.transform = fsm_owner.transform.interpolate_with(
		fsm_owner.transform.looking_at(fsm_owner.target.transform.origin, Vector3.UP),
		 ROTATION_RATE * _delta
		) 
	

func take_hit(value, piercing):
	hit = true
	fsm_owner.take_damage(value, piercing)

func _on_Timer_timeout():
	self.flank_complete = true
	
