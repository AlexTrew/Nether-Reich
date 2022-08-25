extends "res://utils/AbstractFSMState.gd"


# maximum speed in pixels/s 
const SPEED = 3

# acceleration in pixels/s^2
const ACCELERATION = 100

# path to advance along for the duration of this state
var path = []

var advance_complete

var minimum_time_in_state = 1


func _ready():
	var _connection = $AdvancingTimer.connect("timeout", self, "_on_AdvancingTimer_timeout")
	fsm_owner.subscribe_to_get_simple_path_timer(self)


func on_transition_to():
	# advance for a random amount of time at minimum
	hit = false
	advance_complete = false
	$AdvancingTimer.start(minimum_time_in_state + randi() % 2)

func state_physics_process(_delta):
	# walk towards player unless they are too close, then walk away
	var too_close_to_player = (fsm_owner.target.transform.origin - fsm_owner.transform.origin).length() < get_parent().RETREAT_DISTANCE
	var direction_modifier = 1 if too_close_to_player else -1

	if len(path):
		if self.fsm_owner.transform.origin.distance_to(self.path[0]) < 5:
			path.remove(0)

		if len(path):
			var direction = direction_modifier * ((fsm_owner.global_transform.origin - fsm_owner.get_parent().to_global(self.path[0])))
		
			# work out the speed to add this tick (acceleration)
			# note that delta is not used - this motion vector is passed to move_and_slide which will apply delta
			var motion = direction * ACCELERATION
			fsm_owner.motion = fsm_owner.motion + motion

			if self.fsm_owner.motion.length() > SPEED:
				self.fsm_owner.motion = self.fsm_owner.motion.normalized() * SPEED

func state_process(_delta):

	self.fsm_owner.get_node('SpriteHolder').look_at(fsm_owner.target.global_transform.origin, Vector3.UP)
	self.path = self.fsm_owner.navigation.get_simple_path(fsm_owner.transform.origin, fsm_owner.target.transform.origin)


func take_hit(value, piercing):
	fsm_owner.take_damage(value, piercing)
	hit = true
	
func transit():
	var new_state

	if hit:
		new_state = 'RECOILING'
	# AIMING transition function 
	elif get_parent().has_line_of_sight_to_target() && self.advance_complete:
		new_state = 'AIMING'

	return new_state

func _on_AdvancingTimer_timeout():
	self.advance_complete = true

func _on_get_simple_path_timer_timeout():
	self.path = self.fsm_owner.navigation.get_simple_path(fsm_owner.transform.origin, fsm_owner.target.transform.origin)