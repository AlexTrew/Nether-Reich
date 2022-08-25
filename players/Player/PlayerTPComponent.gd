extends Node


var global_transform_origin


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func reparent(end_node):
	var player = self.get_parent().get_instance_id()
	var room = self.get_parent().get_parent().get_instance_id()
	instance_from_id(room).remove_child(instance_from_id(player))
	end_node.add_child(instance_from_id(player))

func teleport(door):
	var id = door.get_instance_id()
	Logger.log(self, str(instance_from_id(id).get_parent()))
	
	reparent(instance_from_id(id).get_parent())

	get_parent().global_transform.origin = instance_from_id(id).global_transform.origin

