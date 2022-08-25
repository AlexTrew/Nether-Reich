extends "res://levels/tiles/AbstractRoom.gd"


func _ready():
	self._register_room_door($Statics/NorthRoomDoor, LevelConstants.GridDirections.NORTH, LevelConstants.CellPositionInTile.ORIGIN)
	self._register_room_door($Statics/EastRoomDoor, LevelConstants.GridDirections.EAST, LevelConstants.CellPositionInTile.ORIGIN)
	self._register_room_door($Statics/SouthRoomDoor, LevelConstants.GridDirections.SOUTH, LevelConstants.CellPositionInTile.ORIGIN)
	self._register_room_door($Statics/WestRoomDoor, LevelConstants.GridDirections.WEST, LevelConstants.CellPositionInTile.ORIGIN)

func connect_tile_signals(level):
	var _artefact_c = $Statics/ArtefactTome.connect("artefact_recovered", level, "_on_Artefact_recovered")

func set_road_rotation(rot):
	pass

