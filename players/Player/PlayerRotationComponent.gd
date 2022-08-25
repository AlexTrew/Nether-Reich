extends Node


var ray_origin
var camera
var ray_target
var component_owner
var mouse_pos

# Called when the node enters the scene tree for the first time.
func _ready():
	component_owner = self.get_parent()
	camera = component_owner.get_parent().get_parent().get_node_or_null("Camera")
	if !camera:
		Logger.error(self, "Level must have a Camera child.", true)


func look_at_cursor():
	var mouse_position_on_viewport = get_viewport().get_mouse_position()
	ray_origin = camera.project_ray_origin(mouse_position_on_viewport)
	ray_target = ray_origin + camera.project_ray_normal(mouse_position_on_viewport) * 1000

	var intersection = component_owner.get_world().direct_space_state.intersect_ray(ray_origin, ray_target, [], 524288)
	
	if(!intersection.empty()):
		mouse_pos = intersection.position
		component_owner.look_at(mouse_pos, Vector3.UP)

		
func get_mouse_position():
	return mouse_pos
