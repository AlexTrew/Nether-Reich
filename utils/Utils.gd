class_name Utils


static func is_node_in_group_in_grouplist(body, group_list):
	for group in group_list:
		if body.is_in_group(group):
			return true

	return false
	
static func get_grid_direction(from_cell, to_cell):
	var direction_to_connected_cell
	
	if to_cell.y > from_cell.y:
		direction_to_connected_cell = LevelConstants.GridDirections.NORTH
		
	if to_cell.x > from_cell.x:
		direction_to_connected_cell = LevelConstants.GridDirections.EAST
		
	if to_cell.y < from_cell.y:
		direction_to_connected_cell = LevelConstants.GridDirections.SOUTH
		
	if to_cell.x < from_cell.x:
		direction_to_connected_cell = LevelConstants.GridDirections.WEST
	
	return direction_to_connected_cell

static func dump_grid(grid):
	Logger.log(null, "Dumping grid...")

	var file = File.new()
	var name = "grid_%s.csv" % OS.get_unix_time()
	var path = "user://%s" % name
	file.open(path, File.WRITE)

	var lines = []

	for y in range(len(grid[0])):
		var row_str = ""

		for x in range(len(grid)):
			var cell = grid[x][y]

			var child_cells_str = ""
			for child_cell in cell.child_cells:
				child_cells_str += "(%s.%s) " % [child_cell.x, child_cell.y]

			var connected_cells_str = ""
			for connected_cell in cell.exits_to_cells:
				connected_cells_str += "(%s.%s) " % [connected_cell.x, connected_cell.y]
			
			var cell_str = ""
			if cell.origin == null:
				cell_str = '"(%s.%s)\nType: %s\nDirection: %s (%s)\nChild cells: %s\nConnected cells: %s\nPath type: %s"'
				row_str += (cell_str % [cell.x, cell.y, cell.type, LevelConstants.direction_symbols[cell.direction], cell.direction, child_cells_str, connected_cells_str, cell.path_type]) + ","

			else:
				var origin_cell_str = "(%s,%s)" % [cell.origin.x, cell.origin.y]
				cell_str = '"(%s.%s)\nType: %s\nOrigin cell: %s\nConnected cells: %s\nPath type: %s"'
				row_str += (cell_str % [cell.x, cell.y, cell.type, origin_cell_str, connected_cells_str, cell.path_type]) + ","
			
		lines.push_front(row_str)
		
	for line in lines:
		file.store_line(line)
	
	file.close()

	Logger.log(null, "Successfully dumped grid to ~/.local/share/godot/app_userdata/Nether Reich Ii/%s" % name)
	return path
