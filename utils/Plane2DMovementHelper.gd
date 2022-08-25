extends Node

const PLANE_Y_HEIGHT_PRIMARY = 1
const PLANE_Y_HEIGHT_SECONDARY = 0.1

var debug = false
var movement_vector = Vector3()


# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_process(self.debug)

func _process(_delta):
	# warn if the parent is not aligned to the expected plane
	if !is_equal_approx(get_parent().global_transform.origin.y, PLANE_Y_HEIGHT_PRIMARY) && !is_equal_approx(get_parent().global_transform.origin.y, PLANE_Y_HEIGHT_SECONDARY):
		Logger.log(self, 'warning - not on 2D plane (actual y: %s, expected y: %s or %s)' % [get_parent().global_transform.origin.y, self.PLANE_Y_HEIGHT_PRIMARY, self.PLANE_Y_HEIGHT_SECONDARY])

func plane_2d_move_and_slide(motion):
	get_parent().move_and_slide(motion)
	if(get_parent().transform.origin.y != PLANE_Y_HEIGHT_PRIMARY):
		get_parent().transform.origin.y = PLANE_Y_HEIGHT_PRIMARY

func plane_2d_vector_length(_vector2):
	pass

func plane_2d_move(direction, speed, delta):
	# assuming we're already on the right plane
	direction = Vector3(direction.x, 0, direction.z)
	get_parent().global_transform.origin += direction * speed * delta

func get_2d_tangent(c, right):
	var modifier = -1 if right else 1
	var tangent2 = Vector2(0,0)
	var tangent3 = Vector3(0,0,0)

	tangent2.x = c.x
	tangent2.y = c.z

	tangent2 = modifier * tangent2.tangent().normalized()

	tangent3.x = tangent2.x
	tangent3.z = tangent2.y

	return tangent3
