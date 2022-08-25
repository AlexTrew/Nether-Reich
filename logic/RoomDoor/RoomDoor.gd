extends "res://logic/AbstractDoor/AbstractDoor.gd"
class_name RoomDoor


var linked_door
var active = false


func set_linked_door(door: RoomDoor):
	linked_door = door

func move_player(player: Player):
	# sends player to linked door in the same level
	var player_pos = player.global_transform.origin

	get_parent().get_parent().player_has_exited()

	Logger.log(self, "player entered this door")
	linked_door.just_entered = true
	linked_door.get_parent().get_parent().player_has_entered()

	Logger.log(self, "exit door at: " + str(linked_door.get_global_transform()))

	self.get_parent().get_parent().call_deferred("remove_child", player)
	linked_door.get_parent().get_parent().call_deferred("add_child", player)
	

	if linked_door.get_parent().get_parent().visible == false:
		linked_door.get_parent().get_parent().visible = true

	player.global_transform.origin = player_pos
	player.global_transform.origin = linked_door.global_transform.origin

	player.set_player_room(linked_door.get_parent().get_parent())
