extends Spatial


var direction_vector


func _ready():
	pass # Replace with function body.

func _process(delta):
	direction_vector = get_parent().global_transform.origin - get_parent().motion.normalized()
	look_at(direction_vector, Vector3.UP)

func get_euler_angle_y():
	return rotation_degrees.y

func get_direction_vector():
	return direction_vector