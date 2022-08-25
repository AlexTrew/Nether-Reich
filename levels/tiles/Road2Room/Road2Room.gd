extends "res://levels/tiles/AbstractRoom.gd"


var road_n_component


func _ready():
	room_type = "road_2"
	road_n_component = $RoadNRoomComponent

	self._register_room_door($Statics/OriginEastRoomDoor, LevelConstants.GridDirections.EAST, LevelConstants.CellPositionInTile.ORIGIN)
	self._register_room_door($Statics/OriginSouthRoomDoor, LevelConstants.GridDirections.SOUTH, LevelConstants.CellPositionInTile.ORIGIN)
	self._register_room_door($Statics/OriginWestRoomDoor, LevelConstants.GridDirections.WEST, LevelConstants.CellPositionInTile.ORIGIN)
	self._register_room_door($Statics/Child0EastRoomDoor, LevelConstants.GridDirections.EAST, LevelConstants.CellPositionInTile.CHILD0)
	self._register_room_door($Statics/Child0WestRoomDoor, LevelConstants.GridDirections.WEST, LevelConstants.CellPositionInTile.CHILD0)
	self._register_room_door($Statics/Child0NorthRoomDoor, LevelConstants.GridDirections.NORTH, LevelConstants.CellPositionInTile.CHILD0)

	$Statics/Trigger.connect("player_entered", self, "_player_entered_trigger_1")
	triggers.append($Statics/Trigger)

	$Statics/RandomItemPickup.add_drop(['pistol', 30])
	$Statics/RandomItemPickup.add_drop(['blunderbus', 30])
	$Statics/RandomItemPickup.add_drop(['cannister_cannon_deployable', 10])
	$Statics/RandomItemPickup.add_drop(['large_energy', 30])
	$Statics/RandomItemPickup.random_drop_pickup()

func set_road_rotation(rot):
	road_n_component.set_road_rotation(rot)

func _player_entered_trigger_1(player):
	$Statics/Spawners/EnemySpawner.set_target()
	$Statics/Spawners/EnemySpawner.add_item_drops([['pistol', 5]])
	$Statics/Spawners/EnemySpawner.spawn_wave(5)


	$Statics/Spawners/EnemySpawner2.set_target()
	$Statics/Spawners/EnemySpawner2.add_item_drops([['pistol', 5], ['blunderbus', 5]])
	$Statics/Spawners/EnemySpawner2.spawn_wave(10)


	$Statics/Spawners/EnemySpawner3.set_target()
	$Statics/Spawners/EnemySpawner3.add_item_drops([['pistol', 5], ['blunderbus', 5]])
	$Statics/Spawners/EnemySpawner3.spawn_wave(15)


	$Statics/Spawners/EnemySpawner4.set_target()
	$Statics/Spawners/EnemySpawner4.add_item_drops([['pistol', 5], ['blunderbus', 5]])
	$Statics/Spawners/EnemySpawner4.spawn_wave(20)

	$Statics/Spawners/EnemySpawner5.set_target()
	$Statics/Spawners/EnemySpawner5.add_item_drops([['pistol', 5], ['blunderbus', 5]])
	$Statics/Spawners/EnemySpawner5.spawn_wave(25)

	$Statics/Spawners/EnemySpawner6.set_target()
	$Statics/Spawners/EnemySpawner6.add_item_drops([['pistol', 5], ['blunderbus', 5]])
	$Statics/Spawners/EnemySpawner6.spawn_wave(30)

	$Statics/Spawners/EnemySpawner7.set_target()
	$Statics/Spawners/EnemySpawner7.add_item_drops([['pistol', 5], ['blunderbus', 5]])
	$Statics/Spawners/EnemySpawner7.spawn_wave(35)
	
	$Statics/Spawners/EnemySpawner8.set_target()
	$Statics/Spawners/EnemySpawner8.add_item_drops([['pistol', 5], ['blunderbus', 5]])
	$Statics/Spawners/EnemySpawner8.spawn_wave(35)