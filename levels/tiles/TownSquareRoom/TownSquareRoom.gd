extends "res://levels/tiles/AbstractRoom.gd"


func _ready():
	self._register_room_door($Statics/OriginSouthRoomDoor, LevelConstants.GridDirections.SOUTH, LevelConstants.CellPositionInTile.ORIGIN)
	self._register_room_door($Statics/OriginWestRoomDoor, LevelConstants.GridDirections.WEST, LevelConstants.CellPositionInTile.ORIGIN)
	self._register_room_door($Statics/Child0EastRoomDoor, LevelConstants.GridDirections.EAST, LevelConstants.CellPositionInTile.CHILD0)
	self._register_room_door($Statics/Child0SouthRoomDoor, LevelConstants.GridDirections.SOUTH, LevelConstants.CellPositionInTile.CHILD0)
	self._register_room_door($Statics/Child1NorthRoomDoor, LevelConstants.GridDirections.NORTH, LevelConstants.CellPositionInTile.CHILD1)
	self._register_room_door($Statics/Child1WestRoomDoor, LevelConstants.GridDirections.WEST, LevelConstants.CellPositionInTile.CHILD1)
	self._register_room_door($Statics/Child2NorthRoomDoor, LevelConstants.GridDirections.NORTH, LevelConstants.CellPositionInTile.CHILD2)
	self._register_room_door($Statics/Child2EastRoomDoor, LevelConstants.GridDirections.EAST, LevelConstants.CellPositionInTile.CHILD2)

func set_road_rotation(rot):
	pass
