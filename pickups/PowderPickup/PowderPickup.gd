extends "res://pickups/AbstractPickup/AbstractPickup.gd"

var direction
var speed
var landed = false

func _ready():
	# cannot be picked up until it has landed (i.e. stopped moving)
	can_be_picked_up = false
	can_be_picked_up_by_groups = ['player']

	speed = 10
	initialise_random_direction()
	$FlightTimer.connect("timeout", self, "_on_FlightTimer_timeout")
	$LifeTimer.connect("timeout", self, "_on_LifeTimer_timeout")
	
	$FlightTimer.start()
	$LifeTimer.start()

func move(delta):
	$Plane2DMovementHelper.plane_2d_move(direction, speed, delta)

func _process(_delta):
	if !landed:
		move(_delta)

func initialise_random_direction():
	var x_direction = rand_range(-5,5)
	var y_direction = rand_range(-5,5)
	direction = Vector3(x_direction, 0, y_direction).normalized()

func _on_LifeTimer_timeout():
	queue_free()

func _on_FlightTimer_timeout():
	landed = true
	can_be_picked_up = true

func on_pickup(picker_upper):
	picker_upper.modify_auto_reload_progress(10)
	queue_free()
