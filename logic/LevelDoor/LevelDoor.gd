extends "res://logic/AbstractDoor/AbstractDoor.gd"
class_name LevelDoor


export(String) var target_level_id

signal change_level


func move_player(player: Player):
    # sends the player to a new level
    Logger.log(self, "Sending the player to a new world of wonder....")
    emit_signal("change_level", target_level_id)
