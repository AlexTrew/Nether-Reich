extends Node


# a reference to the object the state machine controls
var fsm_owner

#have I just been hit?
var hit


func _ready():
	self.fsm_owner = self.get_parent().get_parent()

func on_transition_to():
	# Called every time the state is transitioned to.
	assert(false, 'This function (%s.on_transition_to()) is abstract.' % self.name) 

func transit():
	# Check if we should transition to another state, and return that new state if so.
	assert(false, 'This function (%s.transit()) is abstract.' % self.name) 

func state_process(_delta):
	# Given the state we are in, do whatever should be done this frame.
	assert(false, 'This function (%s.state_process()), invoked on %s, is abstract.' % [self.name, self.fsm_owner.name]) 

func state_physics_process(_delta):
	# Given the state we are in, do whatever should be done this physics frame.
	assert(false, 'This function (%s.state_physics_process()) , invoked on %s, is abstract.' % [self.name, self.fsm_owner.name])

func take_hit(value, piercing):
	# Given the state we are in, do whatever should be done this frame.
	assert(false, 'This function (%s.state_process()), invoked on %s, is abstract.' % [self.name, self.fsm_owner.name]) 
