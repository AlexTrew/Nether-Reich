extends "res://levels/tiles/AbstractRoom.gd"

var road_n_component

func _ready():
	road_n_component = $RoadNRoomComponent

func set_road_rotation(rot):
	pass
	
func spawn_exit_instance_at_location(x, z, name, rot):
	road_n_component.spawn_exit_instance_at_location(x, z, name, rot)
