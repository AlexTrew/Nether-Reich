extends Node
class_name GridCell

var id 
var type = "empty"  # type of room
var x = null
var y = null
var length = 0  # tile length in cells
var direction = 0  # tile direction
var origin = null  # origin cell for the tile, if this is a child cell
var child_cells = []  # other cells in this tile, if this is an origin cell
var exits_to_cells = [] # cells in other tiles which this cell requires doors to

var path_type = "not_on_main_path"  # is the room on the main path of the level?
var visited = false  # visited by DFS
var prev = null  # previous cell in DFS


func _init(x, y, id):
	self.x = x
	self.y = y
	self.id = id
	
func get_info():
	return "(%s,%s). Direction: %s. Length: %s. Child cells: %s. Connected cells: %s." % [x, y, direction, length, len(child_cells), len(exits_to_cells)]