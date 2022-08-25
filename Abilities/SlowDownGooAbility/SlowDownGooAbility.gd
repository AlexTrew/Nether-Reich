extends "res://Abilities/AbstractAbility.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func use_ability():
	if ability_ready:
		emit_goo()
		ability_ready = false
		$AbilityCooldownTimer.start()

func emit_goo():
	