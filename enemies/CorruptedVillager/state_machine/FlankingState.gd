extends "res://utils/AbstractFSMState.gd"


var flank_complete
var flank_right

var tangent2 = Vector2(0,0)
var tangent3 = Vector3(0,0,0)

const SPEED_MIN = 2
const SPEED_MAX = 10

var speed 

# acceleration in pixels/s^2
const ACCELERATION = 75


func _ready():
	var _connection = $FlankingTimer.connect("timeout", self, "_on_Timer_timeout")


func on_transition_to():
	speed = rand_range(SPEED_MIN, SPEED_MAX)
	hit = false
	flank_complete = false
	flank_right = randi() % 2
	$FlankingTimer.start(rand_range(0.5,1.5))

	
func transit():
	var new_state

	if hit:
		new_state = 'RECOILING'
	elif get_parent().has_left_flanking_distance():
		new_state = 'ADVANCING'
		
	# CHARGING transition function
	elif flank_complete:
		new_state = 'PREATTACKING'

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

func state_process(_delta):
	fsm_owner.look_at(fsm_owner.target.global_transform.origin, Vector3.UP)
	

func take_hit(value, piercing):
	fsm_owner.take_damage(value, piercing)
	hit = true


func _on_Timer_timeout():
	self.flank_complete = true
	
