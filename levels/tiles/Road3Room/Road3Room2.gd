extends "res://levels/tiles/AbstractRoom.gd"


var road_n_component


func _init():
	pass

func _ready():
	room_type = "road_3"
	road_n_component = $RoadNRoomComponent

	self._register_room_door($Statics/OriginEastRoomDoor, LevelConstants.GridDirections.EAST, LevelConstants.CellPositionInTile.ORIGIN)
	self._register_room_door($Statics/OriginSouthRoomDoor, LevelConstants.GridDirections.SOUTH, LevelConstants.CellPositionInTile.ORIGIN)
	self._register_room_door($Statics/OriginWestRoomDoor, LevelConstants.GridDirections.WEST, LevelConstants.CellPositionInTile.ORIGIN)
	self._register_room_door($Statics/Child0EastRoomDoor, LevelConstants.GridDirections.EAST, LevelConstants.CellPositionInTile.CHILD0)
	self._register_room_door($Statics/Child0WestRoomDoor, LevelConstants.GridDirections.WEST, LevelConstants.CellPositionInTile.CHILD0)
	self._register_room_door($Statics/Child1NorthRoomDoor, LevelConstants.GridDirections.NORTH, LevelConstants.CellPositionInTile.CHILD1)
	self._register_room_door($Statics/Child1EastRoomDoor, LevelConstants.GridDirections.EAST, LevelConstants.CellPositionInTile.CHILD1)
	self._register_room_door($Statics/Child1WestRoomDoor, LevelConstants.GridDirections.WEST, LevelConstants.CellPositionInTile.CHILD1)

	$Statics/Trigger.connect("player_entered", self, "_on_Trigger_activated")
	$Statics/Trigger2.connect("player_entered", self, "_on_Trigger2_activated")

	triggers.append($Statics/Trigger)
	triggers.append($Statics/Trigger2)

	$Statics/RandomItemPickup.add_drop(['pistol', 30])
	$Statics/RandomItemPickup.add_drop(['blunderbus', 30])
	$Statics/RandomItemPickup.add_drop(['cannister_cannon_deployable', 10])
	$Statics/RandomItemPickup.add_drop(['large_energy', 10])
	$Statics/RandomItemPickup.random_drop_pickup()

	$Statics/RandomItemPickup1.add_drop(['pistol', 30])
	$Statics/RandomItemPickup1.add_drop(['blunderbus', 30])
	$Statics/RandomItemPickup1.add_drop(['cannister_cannon_deployable', 10])
	$Statics/RandomItemPickup1.add_drop(['large_energy', 10])
	$Statics/RandomItemPickup1.random_drop_pickup()
	
func connect_tile_signals(level):
	pass

func set_road_rotation(rot):
	road_n_component.set_road_rotation(rot)

func _on_Trigger_activated(player):

	$Statics/Spawners/EnemySpawner.set_target()
	$Statics/Spawners/EnemySpawner.add_item_drops([['pistol', 5]])
	$Statics/Spawners/EnemySpawner.spawn_wave(0)
	$Statics/Spawners/EnemySpawner.spawn_wave(25)

	
	$Statics/Spawners/EnemySpawner2.set_target()
	$Statics/Spawners/EnemySpawner2.add_item_drops([['pistol', 3], ['blunderbus', 3]])
	$Statics/Spawners/EnemySpawner2.spawn_wave(0)


	self.lock_all_doors()

func _on_Trigger2_activated(player):
	$Statics/Spawners/EnemySpawner3.set_target()
	$Statics/Spawners/EnemySpawner3.add_item_drops([['pistol', 2], ['blunderbus', 3]])
	$Statics/Spawners/EnemySpawner3.spawn_wave(0)

	
	$Statics/Spawners/EnemySpawner4.set_target()
	$Statics/Spawners/EnemySpawner4.add_item_drops([['pistol', 5], ['blunderbus', 5]])
	$Statics/Spawners/EnemySpawner4.spawn_wave(0)

	
func _process(_delta):
	# this could soft lock if a spawner with no trigger exists
	if self.doors_locked and self.have_all_enemies_spawned() and self.count_enemies() == 0:
		self.unlock_all_doors()
