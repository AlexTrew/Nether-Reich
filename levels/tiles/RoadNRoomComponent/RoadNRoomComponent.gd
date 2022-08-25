extends Node


func set_road_rotation(rot):
	var new_rotation_degrees = (rot * 90)
	get_parent().rotate_y(deg2rad(new_rotation_degrees))

