extends Node


var state_objects
var current_state
var current_state_index

signal state_transition(state_index)


func _process(_delta):
	assert(current_state, get_error_message_for_null_state())
	var new_state_index = current_state.transit()
	if new_state_index:
		set_state(new_state_index)

func state_process(delta):
	assert(current_state, get_error_message_for_null_state())
	current_state.state_process(delta)

func state_physics_process(delta):
	assert(current_state, get_error_message_for_null_state())
	current_state.state_physics_process(delta)

func set_state(state_index):
	current_state_index = state_index
	current_state = state_objects[state_index]
	current_state.on_transition_to()
	emit_signal("state_transition", state_index)

func get_current_state_index():
	return current_state_index

func get_error_message_for_null_state():
	return '%s: Current state is %s. FSMs must define a dict of state_objects, and set an inital state using set_state(), in _ready().' % [self.name, str(self.current_state)]
