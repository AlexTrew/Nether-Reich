extends Spatial
class_name AbstractRoom 


var exit_objects_names_instances = {}
var exit_objects_names = []
var triggers = []

var room_type
var doors_locked = false

var id 

var player_entered = false

# This data structure represents the doors available in this tile. The generator will use this to activate the
# appropriate doors.
# Note the directions here are relative to a default-oriented tile.
var _room_doors_by_cell_and_direction = {
	# LevelConstants.CellPositionInTile.ORIGIN: {
	# 	LevelConstants.GridDirections.NORTH: $OriginNorthDoor,
	# 	LevelConstants.GridDirections.EAST: $OriginEastDoor,
	#   etc...
	# },
	# LevelConstants.CellPositionInTile.CHILD0: {
	# 	LevelConstants.GridDirections.NORTH: $Child0NorthDoor,
	# 	LevelConstants.GridDirections.EAST: $Child0EastDoor,
	# }
	# etc...
}


func connect_tile_signals(level):
	self.connect_tile_level_doors(level)

func connect_tile_level_doors(level):
	# If any LevelDoors are present in this tile, connect their signals.
	for child in $Statics.get_children():
		if child is LevelDoor:
			Logger.log(self, "Connected level door %s" % child.name)
			child.connect("change_level", Game, "_on_Level_LevelDoor_activated")

func bake_navmesh_from_template():
	if !(has_node('NavMeshTemplate') && has_node('Navigation')):
		Logger.error(self, "Navigation and NavMeshTemplate child nodes are required to bake enemy navigation.", false)
		return

	var template = $NavMeshTemplate
	var navigation = $Navigation

	var navmesh = NavigationMesh.new()
	navmesh.create_from_mesh(template.mesh)
	var id = navigation.navmesh_add(navmesh, template.transform)
	Logger.log(self, "generated NavigationMesh from MeshInstance with ID %s" % id, "verbose")	

func place_exits(cell: GridCell):
	activate_tile_exits(cell)
	self.delete_inactive_doors()

func _register_room_door(door_node: RoomDoor, direction: int, cell_position_in_tile: int):
	"""
	Adds a door_node placed in the editor to the _room_doors_by_cell_and_direction data structure, which allows the LevelGenerationComponent
	to work out which doors belong to which cells of the tile and in which directions.
	"""
	Logger.log(self, "Registering door %s in cell position %s, direction %s." % [door_node.name, cell_position_in_tile, direction], "verbose")
	if not self._room_doors_by_cell_and_direction.get(cell_position_in_tile):
		self._room_doors_by_cell_and_direction[cell_position_in_tile] = {}
	self._room_doors_by_cell_and_direction[cell_position_in_tile][direction] = door_node

func delete_inactive_doors():
	Logger.log(self, "Deleting inactive doors.")

	for child in $Statics.get_children():
		if child is RoomDoor and !child.active:
			Logger.log(self, "Freeing inactive door %s" % child.name)
			child.queue_free()

func lock_all_doors():
	Logger.log(self, "Locking the doors >:)")
	for child in $Statics.get_children():
		if child.is_in_group("doors"):
			child.lock()
	self.doors_locked = true

func unlock_all_doors():
	Logger.log(self, "Unlocking the doors")
	var counter = 0
	for child in $Statics.get_children():
		if child.is_in_group("doors") && child.locked:
			child.unlock()
			counter += 1
	self.doors_locked = false
	return counter

func count_enemies(include_dead=false):
	var enemies = []
	for child in get_children():
		if child.is_in_group('enemies') && (include_dead || child.get_node("StateMachine").get_current_state_index() != "DEAD"):
				enemies.append(child)
	return len(enemies)

func kill_enemies():
	var counter = 0
	for child in get_children():
		if child.is_in_group('enemies') && child.get_node("StateMachine").get_current_state_index() != "DEAD":
			child.die()
			counter += 1
	return counter

func have_all_enemies_spawned():
	for spawner in $Statics/Spawners.get_children():
		if !spawner.have_all_waves_spawned():
			return false

	return true

func activate_tile_exits(cell: GridCell):
	"""
	This function determines which exits the tile should activate based on the cell and and adjacent cells, and marks them active.
	Linking doors to one another happens later.
	"""

	Logger.log(self, "Activating exits for tile with origin cell %s..." % cell.get_info(), "verbose")

	for connected_cell in cell.exits_to_cells:
		var direction_to_connected_cell = Utils.get_grid_direction(cell, connected_cell)
		var local_exit = _resolve_local_exit_direction(direction_to_connected_cell, cell.direction)

		self._activate_door_instance(LevelConstants.CellPositionInTile.ORIGIN, local_exit, [cell.x, cell.y, direction_to_connected_cell])

	# make recursive?
	for child_cell_index in range(0, len(cell.child_cells)):
		var child_cell = cell.child_cells[child_cell_index]
		for connected_cell in child_cell.exits_to_cells:
			var direction_to_connected_cell = Utils.get_grid_direction(child_cell, connected_cell)
			var local_exit = _resolve_local_exit_direction(direction_to_connected_cell, cell.direction)

			self._activate_door_instance(child_cell_index, local_exit, [child_cell.x, child_cell.y, direction_to_connected_cell])

	Logger.log(self, "...Done.", "verbose")
	
func _activate_door_instance(cell_position_in_tile, door_grid_direction, door_name):
	var door_instance = self._room_doors_by_cell_and_direction[cell_position_in_tile][door_grid_direction]
	door_instance.set_active(true)
	self.exit_objects_names_instances[door_name] = door_instance
	self.exit_objects_names.append(door_name)

func _resolve_local_exit_direction(direction_to_connected_cell, cell_orientation):
	"""
	This function determines the compass direction we will use to find the relevant door node within a tile, which is necessary as the tile may not be at
	default orientation.

	See AbstractRoom._room_doors_by_cell_and_direction
	"""
	var exit_wall = direction_to_connected_cell - cell_orientation
	if exit_wall < 0:
		exit_wall = 4 + exit_wall
	return exit_wall

func player_has_entered():
	player_entered = true
	#use a signal
	get_parent().emit_signal("room_entered", id)

func player_has_exited():
	player_entered = false
	get_parent().emit_signal("room_exited", id)

func _process(_delta):
	# this could soft lock if a spawner with no trigger exists
	if self.doors_locked and self.have_all_enemies_spawned() and self.count_enemies() == 0:
		self.unlock_all_doors()
