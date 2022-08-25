extends "res://ui/Console/commands/AbstractCommand.gd"


func _init():
	keyword = "unlockdoors"
	description = "Unlocks all doors in the map."

func execute(args):
	var counter = 0
	for tile in get_node("/root/Level")._get_level_tiles():
		counter += tile.unlock_all_doors()
	return "Unlocked %s doors." % counter
