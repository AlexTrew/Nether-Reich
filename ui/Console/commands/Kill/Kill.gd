extends "res://ui/Console/commands/AbstractCommand.gd"


func _init():
	keyword = "killall"
	description = "Kills all enemies in the map."

func execute(args):
	var result = get_node("/root/Level").kill_enemies()
	return "%s enemies killed across %s tiles." % [result['enemies_killed'], result['across_tiles']]
