extends Node
var GridCell = preload("res://levels/grid/GridCell.gd")


const grid_size_x = 50
const grid_size_y = 50

var grid = []
var branch_from_square_chance = 60

var exit_objects_names = []
var exit_objects_names_instances = {}

var start_grid_cell
var end_grid_cell

var main_path_rooms = []
var non_main_path_rooms = []

var level_population_component

var rand_generate = RandomNumberGenerator.new()

func _ready():
	var id = 0
	for x_coord in grid_size_x:
		var y_coords = []
		grid.append(y_coords)
		for y_coord in grid_size_y:
			grid[x_coord].append(GridCell.new(x_coord, y_coord, id))
			id = id + 1

	level_population_component = get_parent().get_node("LevelPopulationComponent")

func generate_map(no_of_rooms):
	# this is where the fun begins
	simple_linear_walker(no_of_rooms)


	if ProjectSettings.get_setting("netherreich/logging/dump_grid_as_csv"):
		Utils.dump_grid(self.grid)
	
	var start_pos = place_map_scenes()
	_connect_doors()

	return start_pos

	# this should be done in level script!
func populate_rooms_with_enemies(difficulty):
	level_population_component.populate_rooms(main_path_rooms, difficulty)

	var random_rooms = get_random_room_list(40, non_main_path_rooms)
	level_population_component.populate_rooms(random_rooms, difficulty)

func _connect_doors():
	for exit in exit_objects_names:
		var exit_direction = exit[2]
		var linked_door

		if exit_direction == LevelConstants.GridDirections.NORTH:
			linked_door = [exit[0], exit[1] + 1, LevelConstants.GridDirections.SOUTH]
		if exit_direction == LevelConstants.GridDirections.EAST:
			linked_door = [exit[0] + 1, exit[1], LevelConstants.GridDirections.WEST]
		if exit_direction == LevelConstants.GridDirections.SOUTH:
			linked_door = [exit[0], exit[1] - 1, LevelConstants.GridDirections.NORTH]
		if exit_direction == LevelConstants.GridDirections.WEST:
			linked_door = [exit[0] - 1, exit[1], LevelConstants.GridDirections.EAST]
		
		if !linked_door in exit_objects_names_instances:
			Logger.log(self, "Cannot link door %s to destination door %s, which does not exist." % [str(exit), str(linked_door)])
		else:
			exit_objects_names_instances[exit].set_linked_door(exit_objects_names_instances[linked_door])
			Logger.log(self, str(exit) + " is connected to " + str(linked_door), "verbose")

	# by this point, all exits should be linked
	var unlinked_exits = []
	for exit in exit_objects_names:
		if exit_objects_names_instances[exit].linked_door == null:
			unlinked_exits.append(exit)
	
	if len(unlinked_exits):
		for exit in unlinked_exits:
			Logger.error(self, "Door still has no linked door: " + str(exit))
		Logger.error(self, "Unexpected doors with no linked door exist.", true)

func simple_linear_walker(no_of_rooms):
	Logger.log(self, "Starting walker...")

	

	var cursor_x = 25
	var cursor_y = 25

	var _prev_x = cursor_x
	var _prev_y = cursor_y

	grid[cursor_x][cursor_y].type = "start"


	start_grid_cell = grid[cursor_x][cursor_y]

	cursor_y -= 1

	var spawned_rooms_count = 0

	var previous_walk_direction = LevelConstants.GridDirections.SOUTH

	while spawned_rooms_count < no_of_rooms:

		rand_generate.randomize()

		connect_cells_via_exit(grid[_prev_x][_prev_y], grid[cursor_x][cursor_y])
		set_cell_type_origin(grid[cursor_x][cursor_y])

		var current_road_target_length = rand_generate.randi_range(2, 3)
		var current_road_length = 1

		var walk_direction = generate_new_walk_direction(previous_walk_direction)
		previous_walk_direction = walk_direction

		var room_origin = grid[cursor_x][cursor_y]
		set_room_to_main_path_from_origin_cell(room_origin)
		set_cell_direction(room_origin, walk_direction)

		while current_road_length < current_road_target_length:

			if walk_direction == LevelConstants.GridDirections.SOUTH:
				cursor_y -= 1
			elif walk_direction == LevelConstants.GridDirections.EAST:
				cursor_x += 1
			elif walk_direction == LevelConstants.GridDirections.WEST:
				cursor_x -= 1

			set_cell_direction(grid[cursor_x][cursor_y], walk_direction)
			connect_cell_to_room_origin(grid[cursor_x][cursor_y], room_origin)
			
			set_cell_type_road(grid[cursor_x][cursor_y])

			current_road_length+=1
			set_origin_cell_length(room_origin, current_road_length)

			

		_prev_x = cursor_x
		_prev_y = cursor_y

		if walk_direction == LevelConstants.GridDirections.SOUTH:
			cursor_y -= 1
		elif walk_direction == LevelConstants.GridDirections.EAST:
			cursor_x += 1
		elif walk_direction == LevelConstants.GridDirections.WEST:
			cursor_x -= 1

		spawned_rooms_count+=1

	add_end_room(grid[cursor_x][cursor_y], _prev_x, _prev_y)

		

	Logger.log(self, "Walker complete.")


func set_cell_direction(cell, direction):
	cell.direction = direction

func set_room_to_main_path_from_origin_cell(cell):
	cell.path_type = "main_path"



func generate_new_walk_direction(previous_direction):

	rand_generate.randomize()

	var viable_directions = [LevelConstants.GridDirections.EAST, LevelConstants.GridDirections.SOUTH, LevelConstants.GridDirections.WEST]
	var new_direction = viable_directions[rand_generate.randi() % len(viable_directions)]
	new_direction = set_backtracking_walk_direction_to_north(previous_direction, new_direction)
	return new_direction;


func set_backtracking_walk_direction_to_north(previous_direction, new_direction):
	if previous_direction != LevelConstants.GridDirections.SOUTH:
		new_direction = LevelConstants.GridDirections.SOUTH
	return new_direction


func connect_cell_to_room_origin(cell, origin):
	cell.origin = origin
	origin.child_cells.append(cell)

func connect_cells_via_exit(cell1, cell2):
	cell1.exits_to_cells.append(cell2)
	cell2.exits_to_cells.append(cell1)

func set_cell_type_origin(room):
	room.type = "road_origin"

func set_cell_type_road(room):
	room.type = "road"

func set_origin_cell_length(cell, length):
	cell.length = length


func add_end_room(cell, prev_x, prev_y):
	cell.type = "end"
	connect_cells_via_exit(cell, grid[prev_x][prev_y])


func place_map_scenes():
	
	var level = get_parent()

	#road 1 rooms
	var road_1_room = preload("res://levels/tiles/Road1Room/Road1Room.tscn")

	#road 2 rooms
	var road_2_room = preload("res://levels/tiles/Road2Room/Road2Room.tscn")

	#road 3 rooms (town)
	var road_3_room = preload("res://levels/tiles/Road3Room/Road3Room.tscn")
	var road_3_room1 = preload("res://levels/tiles/Road3Room/Road3Room1.tscn")
	var road_3_room2 = preload("res://levels/tiles/Road3Room/Road3Room2.tscn")
	var road_3_room3 = preload("res://levels/tiles/Road3Room/Road3Room3.tscn")

	var road_3_rooms = [road_3_room, road_3_room1, road_3_room2, road_3_room3]

	var road_4_room = preload("res://levels/tiles/Road4Room/Road4Room.tscn")
	var town_square_room = preload("res://levels/tiles/TownSquareRoom/TownSquareRoom.tscn")
	var start_room = preload("res://levels/tiles/StartRoom/StartRoom.tscn")
	var artefact_room = preload("res://levels/tiles/ArtefactRoom/ArtefactRoom.tscn")

	var start_pos 

	for row in grid:
		for cell in row:
			var to_spawn = null

			if cell.type == "square_origin":
				to_spawn = town_square_room
			if cell.type == "road_origin":
				if cell.length == 1:
					to_spawn = road_1_room
				if cell.length == 2:
					to_spawn = road_2_room
				if cell.length == 3:
					var list_index = randi() % len(road_3_rooms)
					to_spawn = road_3_rooms[list_index]
				if cell.length == 4:
					to_spawn = road_4_room
			
			if cell.type == "start":
				to_spawn = start_room
				for exit in cell.exits_to_cells:
					Logger.log(self, str(exit), "verbose")
			if cell.type == "end":
				to_spawn = artefact_room
			
			if to_spawn != null:
				start_pos = self.add_tile(level, to_spawn, cell)

	return start_pos

func get_room_origin(room_cell):
	if(room_cell.type == "road_origin" || room_cell.type == "square_origin"):
		return room_cell
	elif(room_cell.type == "road" || room_cell.type == "square"):
		return room_cell.origin
	else:
		return room_cell

func assign_rooms_on_path(path, assignment):
	for room in path:
		room.path_type = assignment

func find_path_between_rooms(grid, start_room, end_room):
	Logger.log(self, "Finding path between rooms...")

	#stack composed of [room, adjacent_rooms[]]
	var stack = [[start_room, []]]

	#depth first search; make sure to only add room origins with the get_room_origin function!
	while(len(stack) != 0):

		if stack[-1][0].type == "end":
			break

		#get exits from room origin
		if stack[-1][0].visited == false:
			for exit in stack[-1][0].exits_to_cells:
				stack[-1][1].append(exit)

			for child in stack[-1][0].child_cells:
				for exit in child.exits_to_cells:
					stack[-1][1].append(exit)

		var s = stack[-1]
		stack.pop_back()

		if s[0].visited == false:
			s[0].visited = true

		for adj_room in s[1]:
			var adj_room_origin = get_room_origin(adj_room)
			if adj_room_origin.visited == false:
				adj_room_origin.prev = s[0]
				stack.append([adj_room_origin, []])
	
	var path = [] 
	
	var current_room = end_room

	while current_room.type != "start":
		path.push_front(current_room)
		current_room = current_room.prev
	path.push_front(start_room)
	Logger.log(self, "Found path between rooms.")
	
	return path

func add_tile(level, scene, cell):
	var start_pos

	var tile_instance = scene.instance()
	tile_instance.add_to_group('level_tiles')
	level.add_child(tile_instance)
	tile_instance.connect_tile_signals(level)

	tile_instance.global_transform.origin = Vector3(cell.x * LevelConstants.CELL_SIZE, 0 , cell.y * LevelConstants.CELL_SIZE)
	tile_instance.set_road_rotation(cell.direction)
	tile_instance.bake_navmesh_from_template()
	
	if cell.type in ["road_origin", "square_origin", "start", "end"]:
		tile_instance.place_exits(cell)

		tile_instance.id = cell.id
		
		for exit in tile_instance.exit_objects_names:
			exit_objects_names.append(exit)
		
		for key in tile_instance.exit_objects_names_instances:
			exit_objects_names_instances[key] = tile_instance.exit_objects_names_instances[key]
		if cell.type == "start":
			start_pos = tile_instance.global_transform.origin
		if cell.type != 'start' && !ProjectSettings.get_setting("netherreich/gameplay/disable_map_exploration"):
			tile_instance.visible = false
		
		if cell.path_type == "main_path":
			main_path_rooms.append(tile_instance)
		if cell.path_type == "not_on_main_path":
			non_main_path_rooms.append(tile_instance)
		
	return start_pos

func map_cell_to_tile(tile_instance, cell):
	tile_instance.id = cell.id
	get_parent().id_to_room_map[cell.id] = tile_instance

func map_cell_to_mapui_tile():
	pass

func get_random_room_list(selection_per_cent_prob, room_list):
	randomize()
	var output_room_list = []
	for room in room_list:
		var chance = randi() % 100
		if chance > (100 - selection_per_cent_prob):
			output_room_list.append(room)
	return output_room_list
