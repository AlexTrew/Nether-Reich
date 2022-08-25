extends Node
class_name AbstractCommand


var keyword
var description


func execute(args):
	Logger.error(self, "Subclasses must implement this method", true)
