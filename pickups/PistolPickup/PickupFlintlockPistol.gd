extends "res://pickups/AbstractPickup/AbstractPickup.gd"

func _ready():
	pass # Replace with function body.


func _process(_delta):
	for body in get_overlapping_bodies():
		if body.is_in_group('player'):
			if Input.is_action_just_pressed("right_click"):
				body.drop_left_hand_item()
				body.play_pickup_sound()
				body.set_left_hand_item('pistol')
				body.get_node("Rifle").get_node("RifleFSM").set_state("loaded_round_shot")
				queue_free()
