extends "res://levels/tiles/AbstractRoom.gd"


var camera_target
var camera 


func _ready():
	$PosessedSwordsman.health = 10000
	$PosessedSwordsman.attack_damage = 0
	$PosessedSwordsman.target = get_node("Player")
	$PosessedSwordsman.navigation = $Navigation


