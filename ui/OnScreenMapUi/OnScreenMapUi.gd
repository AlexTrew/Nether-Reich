extends TextureRect

var id_to_room_mapui = {}

var start_room_mapui = preload("res://ui/OnScreenMapUi/Room1Start_mapui.tscn")

var road_1_room_mapui = preload("res://ui/OnScreenMapUi/Room1_mapui.tscn")
var road_2_room_mapui = preload("res://ui/OnScreenMapUi/Room2_mapui.tscn")
var road_3_room_mapui = preload("res://ui/OnScreenMapUi/Room3_mapui.tscn")
var town_square_room_mapui = preload("res://ui/OnScreenMapUi/TownSquare_mapui.tscn")
var artefact_room_mapui = preload("res://ui/OnScreenMapUi/ArtefactRoom_mapui.tscn")
var door_mapui = preload("res://ui/OnScreenMapUi/Door_mapui.tscn")

var grid
var current_room

func _ready():
	Logger.log(self, "Entered scene tree")
	# note that this is not a subclass of AbstractUI as it only ever exists as a child of GameUI
	get_node("/root/Level").connect("room_entered", self, "_on_room_entered")
	get_node("/root/Level").connect("room_exited", self, "_on_room_exited")
	$FlickerTimer.connect("timeout", self, "_on_flicker_timer_timeout")

	Game.connect("map_grid_signal", self, "_on_map_grid_signal_received")
	# todo: this is necessary due to a race condition where the above signal is fired before this object exists, fix it
	# or redesign
	if !grid and Game.grid:
		self.draw_map_from_grid(Game.grid)

#called when map gets displayed on screen
func display_map():
	visible = true
	if $FlickerTimer.is_stopped():
		$FlickerTimer.start()

func undisplay_map():
	visible = false
	$FlickerTimer.stop()

func draw_map_from_grid(grid):
	
	var start_pos 
	var cell_count = 0

	for row in grid:
		for cell in row:

			var to_spawn = null

			if cell.type == "start":
				to_spawn = start_room_mapui
			if cell.type == "square_origin":
				to_spawn = town_square_room_mapui
			if cell.type == "road_origin":
				if cell.length == 1:
					to_spawn = road_1_room_mapui
				if cell.length == 2:
					to_spawn = road_2_room_mapui
				if cell.length == 3:
					to_spawn = road_3_room_mapui
			
			if cell.type == "start":
				to_spawn = start_room_mapui
				for exit in cell.exits_to_cells:
					Logger.log(self, str(exit), "verbose")
			if cell.type == "end":
				to_spawn = artefact_room_mapui
			
			if to_spawn != null:
				start_pos = self.add_mapui_tile(to_spawn, cell)

			cell_count += 1

	Logger.log(self, "Processed %s cells" % cell_count)
	add_doors_to_map(grid)

func add_mapui_tile(to_spawn, cell):
	var tile = to_spawn.instance()
	add_child(tile)

	if(cell.type == "start"):
		current_room = tile
	elif !ProjectSettings.get_setting("netherreich/gameplay/disable_map_exploration"):
		tile.visible = false

	tile.rect_position.x = cell.x * 10 - 80
	tile.rect_position.y = cell.y * 10 - 120
	
	var new_rotation_degrees = -(cell.direction * 90)
	tile.rect_rotation = new_rotation_degrees

	id_to_room_mapui[cell.id] = tile

func add_doors_to_map(grid):
	for x in grid:
		for cell in x:
			for exit in cell.exits_to_cells:
				if exit.type != "possible_start_end" && cell.type != "possible_start_end":
					var door = door_mapui.instance()
					add_child(door)
					door.rect_position.x = (cell.x * 10 - 80) + 3
					door.rect_position.y = (cell.y * 10 - 120) + 6
					var direction 

					# todo: there's a utility function for this
					if exit.x > cell.x:
						direction = 1
					if exit.x < cell.x:
						direction = 3
					if exit.y < cell.y:
						direction = 2
					if exit.y > cell.y:
						direction = 0

					var new_rotation_degrees = -(direction * 90)
					door.rect_rotation = new_rotation_degrees

func _on_map_grid_signal_received(grid):
	self.grid = grid
	Logger.log(self, "Received grid from Game")
	draw_map_from_grid(grid)

func _on_room_entered(room_id):
	if $FlickerTimer.is_stopped():
		$FlickerTimer.start()
	id_to_room_mapui[room_id].visible = true
	current_room = id_to_room_mapui[room_id]

func _on_room_exited(room_id):
	$FlickerTimer.stop()
	id_to_room_mapui[room_id].visible = true

func _on_flicker_timer_timeout():
	if current_room:
		$MapLoadFailureLabel.visible = false
		if current_room.visible:
			current_room.visible = false
		else:
			current_room.visible = true
	else:
		$MapLoadFailureLabel.visible = true
