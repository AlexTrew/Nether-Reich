extends Node


var acceleration
var deceleration
var speed
var component_owner

func _ready():
	component_owner = self.get_parent()

# Called when the node enters the scene tree for the first time.
func set_params(tspeed, tacceleration, tdeceleration):
	self.acceleration = tacceleration
	self.speed = tspeed
	self.deceleration = tdeceleration


func movement():
	if Input.is_action_pressed("d"):
		component_owner.motion.x += acceleration
	
	elif component_owner.motion.x > 0:
		
		component_owner.motion.x = max(0, component_owner.motion.x - deceleration)

	if Input.is_action_pressed("a"):
		component_owner.motion.x -= acceleration

	elif component_owner.motion.x < 0:
		
		component_owner.motion.x = min(0, component_owner.motion.x + deceleration)
	
	# handle y-axis movement
	if Input.is_action_pressed("w"):
		component_owner.motion.z -= acceleration
	
	elif component_owner.motion.z < 0:
		component_owner.motion.z = min(0, component_owner.motion.z + deceleration)

	if Input.is_action_pressed("s"):
		component_owner.motion.z += acceleration
	
	elif component_owner.motion.z > 0:
		component_owner.motion.z = max(0, component_owner.motion.z - deceleration)

	if component_owner.motion.length() > speed:
		component_owner.motion = component_owner.motion.normalized() * speed
	
	component_owner.get_node("Plane2DMovementHelper").plane_2d_move_and_slide(component_owner.motion)
