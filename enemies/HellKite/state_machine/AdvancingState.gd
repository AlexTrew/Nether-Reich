extends "res://utils/AbstractFSMState.gd"

# maximum speed in pixels/s 
const SPEED = 8

# acceleration in pixels/s^2
const ACCELERATION = 15

# path to advance along for the duration of this state
var path = []

func _ready():
	fsm_owner.subscribe_to_get_simple_path_timer(self)

func state_physics_process(_delta):
	if len(path):
		if self.fsm_owner.transform.origin.distance_to(self.path[0]) < 15:
			path.remove(0)

		if len(path):
			var direction = (fsm_owner.global_transform.origin.direction_to(fsm_owner.get_parent().to_global(self.path[0])))
			
			# work out the speed to add this tick (acceleration)
			# note that delta is not used - this motion vector is passed to move_and_slide which will apply delta
			var motion = direction * ACCELERATION
			fsm_owner.motion = fsm_owner.motion + motion

			if self.fsm_owner.motion.length() > SPEED:
				self.fsm_owner.motion = self.fsm_owner.motion.normalized() * SPEED

func state_process(_delta):
	fsm_owner.look_at(fsm_owner.target.global_transform.origin, Vector3.UP)

	# draw the path for debug purposes
	#self.draw_path()
	
func transit():
	var new_state

	# FLANKING transition function
	if get_parent().is_at_flanking_distance():
		new_state = 'FLANKING'
	
	else:
		new_state = 'ADVANCING'

	return new_state

func set_aggressiveness_mod(value):
	pass

func on_transition_to():
	pass

func draw_path():
	# some debug visualisation
	for indicator in get_tree().get_nodes_in_group("indicators"):
		indicator.free()

	for point in self.path:
		var indicator = MeshInstance.new()
		indicator.mesh = preload("res://utils/NavmeshVisualisationPoint/NavmeshVisPoint.tres")
		indicator.global_transform.origin = point
		indicator.add_to_group("indicators")
		fsm_owner.get_parent().add_child(indicator)



func _on_get_simple_path_timer_timeout():
	self.path = self.fsm_owner.navigation.get_simple_path(fsm_owner.transform.origin, fsm_owner.target.transform.origin)