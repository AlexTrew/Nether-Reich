extends "res://utils/AbstractFSMState.gd"


const speed = 3
const acceleration = 0.5
const deceleration = 1

var transition_done

var ray_origin = Vector3()
var ray_target = Vector3()
var camera

func _ready():
	pass

func on_transition_to():
	camera = fsm_owner.get_parent().get_node("Camera")

	var _c = get_parent().get_node("MovementTypeTransitionTimer").connect("timeout", self, "_on_movement_type_transition_timer_timeout")
	transition_done = false
	get_parent().get_node("MovementTypeTransitionTimer").start()


func transit():
	if(transition_done):
		if !Input.is_action_pressed("space"):
			return 'running'
		else:
			return 'using_left_hand_item'



func state_process(_delta):
	#mouselook implemented here
	var mouse_position_on_viewport = get_viewport().get_mouse_position()
	ray_origin = camera.project_ray_origin(mouse_position_on_viewport)
	ray_target = ray_origin + camera.project_ray_normal(mouse_position_on_viewport) * 1000

	var intersection = fsm_owner.get_world().direct_space_state.intersect_ray(ray_origin, ray_target, [], 524288)
	
	if(!intersection.empty()):
		var pos = intersection.position
		fsm_owner.look_at(pos, Vector3.UP)

func state_physics_process(_delta):
	# handle x-axis movement
	if Input.is_action_pressed("d"):
		self.fsm_owner.motion.x += acceleration
	
	elif self.fsm_owner.motion.x > 0:
		
		self.fsm_owner.motion.x = max(0, self.fsm_owner.motion.x - deceleration)

	if Input.is_action_pressed("a"):
		self.fsm_owner.motion.x -= acceleration

	elif self.fsm_owner.motion.x < 0:
		
		self.fsm_owner.motion.x = min(0, self.fsm_owner.motion.x + deceleration)
	
	# handle y-axis movement
	if Input.is_action_pressed("w"):
		self.fsm_owner.motion.z -= acceleration
	
	elif self.fsm_owner.motion.z < 0:
		self.fsm_owner.motion.z = min(0, self.fsm_owner.motion.z + deceleration)

	if Input.is_action_pressed("s"):
		self.fsm_owner.motion.z += acceleration
	
	elif self.fsm_owner.motion.z > 0:
		self.fsm_owner.motion.z = max(0, self.fsm_owner.motion.z - deceleration)

	if self.fsm_owner.motion.length() > speed:
		self.fsm_owner.motion = self.fsm_owner.motion.normalized() * speed
		
	return self.fsm_owner.move_and_slide_2d(self.fsm_owner.motion)

func _on_movement_type_transition_timer_timeout():
	transition_done = true