extends "res://pickups/AbstractPickup/AbstractPickup.gd"

var direction
var speed
var init_deceleration = 0.001

var initial_movement

var x_direction 
var y_direction


func _ready():
	can_be_picked_up_by_groups = ['player']
	can_be_picked_up = false

	initial_movement = true
	speed = 100
	initialise_random_direction()
	$InitMovementTimer.connect("timeout", self, "_on_init_movement_timeout")
	$LifeTimer.connect("timeout", self, "_on_life_timer_timeout")
	$InitMovementTimer.start()
	$LifeTimer.start()


func move(delta):
	$Plane2DMovementHelper.plane_2d_move(direction, speed, delta)


func _process(_delta):
	move(_delta)

func initialise_random_direction():
	x_direction = rand_range(-5,5)
	y_direction = rand_range(-5,5)
	direction = Vector3(x_direction, 0, y_direction).normalized()

func _on_life_timer_timeout():
	queue_free()

func _on_init_movement_timeout():
	initialise_random_direction()
	speed = 3
	initial_movement = false
	can_be_picked_up = true

func on_pickup(picker_upper):
	picker_upper.recharge_healh_resoration(5)
	picker_upper.play_energy_pickup_sound()
	queue_free()
