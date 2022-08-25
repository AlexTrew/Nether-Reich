extends Spatial

var legs_direction_helper

signal play_reverse_legs_animation(reverse)
signal play_move_right_legs_animation
signal play_move_left_legs_animation

var moving_forward = false
var moving_backward  = false
var moving_left = false
var moving_right = false


# Called when the node enters the scene tree for the first time.
func _ready():
	legs_direction_helper = get_parent().get_node("LegsDirectionHelper")

func _process(delta):

	var movement_angle = legs_direction_helper.get_euler_angle_y()

#break these into separate functions

	if !moving_right && movement_angle < 120 && movement_angle > 60 :
		send_legs_moving_right_signal()

	elif !moving_left && movement_angle > -120 && movement_angle < -60 :
		send_legs_moving_left_signal()

	elif !moving_backward && movement_angle > -60 && movement_angle < 60 :
		send_legs_moving_backwards_signal()

	elif !moving_forward:
		send_legs_moving_forward_signal()


func send_legs_moving_forward_signal():

	emit_signal("play_reverse_legs_animation", false)
	look_at(legs_direction_helper.get_direction_vector(), Vector3.UP)

	var moving_forward = true
	var moving_backward  = false
	var moving_left = false
	var moving_right = false


func send_legs_moving_backwards_signal():
	emit_signal("play_reverse_legs_animation", true)
	rotation_degrees = Vector3(0,180,0)

	var moving_forward = false
	var moving_backward  = true
	var moving_left = false
	var moving_right = false


func send_legs_moving_left_signal():
	emit_signal("play_move_left_legs_animation")
	rotation_degrees = Vector3(0,180,0)

	var moving_forward = false
	var moving_backward  = false
	var moving_left = true
	var moving_right = false


func send_legs_moving_right_signal():

	emit_signal("play_move_right_legs_animation")
	rotation_degrees = Vector3(0,180,0)

	var moving_forward = false
	var moving_backward  = false
	var moving_left = false
	var moving_right = true