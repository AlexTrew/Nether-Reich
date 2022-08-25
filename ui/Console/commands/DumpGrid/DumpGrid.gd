extends "res://ui/Console/commands/AbstractCommand.gd"


func _init():
	keyword = "dumpgrid"
	description = "Saves the generated grid, if any, to user storage."

func execute(args):
	var result = Utils.dump_grid(Game.grid)
	return "Dumped grid to path %s" % result
