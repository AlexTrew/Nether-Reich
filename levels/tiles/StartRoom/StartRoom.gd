extends "res://levels/tiles/AbstractRoom.gd"


func _ready():
	self._register_room_door($Statics/NorthRoomDoor, LevelConstants.GridDirections.NORTH, LevelConstants.CellPositionInTile.ORIGIN)
	self._register_room_door($Statics/EastRoomDoor, LevelConstants.GridDirections.EAST, LevelConstants.CellPositionInTile.ORIGIN)
	self._register_room_door($Statics/SouthRoomDoor, LevelConstants.GridDirections.SOUTH, LevelConstants.CellPositionInTile.ORIGIN)
	self._register_room_door($Statics/WestRoomDoor, LevelConstants.GridDirections.WEST, LevelConstants.CellPositionInTile.ORIGIN)

	$PlayerPresentTrigger.retrigger = true


func connect_tile_signals(level):
	.connect_tile_signals(level)
	var _player_present = $PlayerPresentTrigger.connect("player_entered", Game, "_on_Level_Player_at_spawn")
	var _player_dead_conn = $Player.connect("dead", Game, "_on_Player_dead")

func set_road_rotation(rot):
	pass

