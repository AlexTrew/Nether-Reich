extends "res://levels/tiles/AbstractRoom.gd"


var road_n_component


func _ready():
	room_type = "road_1"
	road_n_component = $RoadNRoomComponent

	self._register_room_door($Statics/NorthRoomDoor, LevelConstants.GridDirections.NORTH, LevelConstants.CellPositionInTile.ORIGIN)
	self._register_room_door($Statics/EastRoomDoor, LevelConstants.GridDirections.EAST, LevelConstants.CellPositionInTile.ORIGIN)
	self._register_room_door($Statics/SouthRoomDoor, LevelConstants.GridDirections.SOUTH, LevelConstants.CellPositionInTile.ORIGIN)
	self._register_room_door($Statics/WestRoomDoor, LevelConstants.GridDirections.WEST, LevelConstants.CellPositionInTile.ORIGIN)


	$Statics/RandomItemPickup.add_drop(['pistol', 60])
	$Statics/RandomItemPickup.add_drop(['blunderbus', 60])
	$Statics/RandomItemPickup.add_drop(['cannister_cannon_deployable', 30])
	$Statics/RandomItemPickup.add_drop(['large_energy', 60])
	$Statics/RandomItemPickup.random_drop_pickup()

func set_road_rotation(rot):
	road_n_component.set_road_rotation(rot)

