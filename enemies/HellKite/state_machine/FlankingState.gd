extends "res://utils/AbstractFSMState.gd"


var flank_complete
var flank_right

var tangent2 = Vector2(0,0)
var tangent3 = Vector3(0,0,0)

# maximum speed in pixels/s 
const SPEED = 2

# acceleration in pixels/s^2
const ACCELERATION = 75


func _ready():
	var _connection = $FlankingTimer.connect("timeout", self, "_on_Timer_timeout")


func on_transition_to():
	fsm_owner.get_node("InhaleAudioStreamPlayer3D").play()
	fsm_owner.get_node("AnimatedSprite").frame = 0;
	flank_complete = false
	$FlankingTimer.start()

	
func transit():
	var new_state

	# ADVANCING transition function:
	if get_parent().has_left_flanking_distance():
		new_state = 'ADVANCING'
		
	# CHARGING transition function
	elif flank_complete:
		new_state = 'ATTACKING'

	return new_state


func state_physics_process(_delta):
	var forward = (fsm_owner.global_transform.origin - fsm_owner.target.global_transform.origin)

	var tangent = fsm_owner.get_node("Plane2DMovementHelper").get_2d_tangent(forward, flank_right)

	# work out the speed to add this tick (acceleration)
	# note that delta is not used - this motion vector is passed to move_and_slide which will apply delta
	var motion = tangent * ACCELERATION

	fsm_owner.motion = fsm_owner.motion + motion

	if(fsm_owner.motion.length() > SPEED):
		fsm_owner.motion = fsm_owner.motion.normalized() * SPEED

func state_process(_delta):
	fsm_owner.look_at(fsm_owner.target.global_transform.origin, Vector3.UP)


func take_hit(value, piercing):
	fsm_owner.take_damage(value, piercing)
	

func _on_Timer_timeout():
	self.flank_complete = true
	
