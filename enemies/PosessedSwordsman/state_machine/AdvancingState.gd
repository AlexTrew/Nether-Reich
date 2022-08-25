extends "res://utils/AbstractFSMState.gd"

# maximum speed in pixels/s 
const SPEED = 9

# acceleration in pixels/s^2
const ACCELERATION = 15

const ROTATION_RATE = 8
const enter_flank_delay = 0.6

var enter_flank
var timer_started

# path to advance along for the duration of this state
var path = []

func _ready():
	$EnterFlankTimer.connect("timeout", self, "_on_enter_flank_timer_timeout")
	$EnterFlankTimer.wait_time = enter_flank_delay
	fsm_owner.subscribe_to_get_simple_path_timer(self)


func state_physics_process(_delta):
	if len(path):
		if self.fsm_owner.transform.origin.distance_to(self.path[0]) < 5:
			path.remove(0)

		if len(path):
			var direction = (fsm_owner.global_transform.origin.direction_to(fsm_owner.get_parent().to_global(self.path[0])))
			#((fsm_owner.global_transform.origin - fsm_owner.to_global(self.path[0])).normalized())
			
			# work out the speed to add this tick (acceleration)
			# note that delta is not used - this motion vector is passed to move_and_slide which will apply delta
			var motion = direction * ACCELERATION
			fsm_owner.motion = fsm_owner.motion + motion

			if self.fsm_owner.motion.length() > SPEED:
				self.fsm_owner.motion = self.fsm_owner.motion.normalized() * SPEED


func state_process(_delta):
	if fsm_owner.target:
		fsm_owner.transform = fsm_owner.transform.interpolate_with(
			fsm_owner.transform.looking_at(fsm_owner.target.transform.origin, Vector3.UP),
			ROTATION_RATE * _delta
			) 

	if get_parent().is_at_flanking_distance():
		if !timer_started:
			timer_started = true
			$EnterFlankTimer.start()

	if get_parent().has_left_flanking_distance() && timer_started:
		$EnterFlankTimer.stop()
		timer_started = false


func transit():
	var new_state
	# FLANKING transition function

	if hit:
		new_state = 'RECOILING'
	
	elif get_parent().closer_than_flanking_distance():
		new_state = 'SIDESTEP'

	elif enter_flank:
		if randf() > 0.7:
			new_state = 'FLANKING'
		else:
			new_state = 'FLANKINGBLOCKING'

	return new_state


func set_aggressiveness_mod(value):
	pass


func take_hit(value, piercing):
	fsm_owner.take_damage(value, piercing)
	hit = true


func on_transition_to():
	fsm_owner.get_node("AnimatedSpriteLegs").animation = "move"
	hit = false
	fsm_owner.play_footstep_sound("running")
	timer_started = false
	enter_flank = false


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

func _on_enter_flank_timer_timeout():
	enter_flank = true


func _on_get_simple_path_timer_timeout():
	self.path = self.fsm_owner.navigation.get_simple_path(fsm_owner.transform.origin, fsm_owner.target.transform.origin)