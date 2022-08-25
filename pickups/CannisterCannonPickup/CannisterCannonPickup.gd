extends "res://pickups/AbstractPickup/AbstractPickup.gd"

func _ready():
	pass


func _process(_delta):
	for body in get_overlapping_bodies():
		if body.is_in_group('player'):
			if Input.is_action_just_pressed("right_click"):
				if !body.has_ability('summon_cannon'):
					body.play_pickup_sound()
					body.load_ability('summon_cannon', 1)
					queue_free()