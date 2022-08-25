extends "res://utils/AbstractShot.gd"


func _ready():
	damage = 10
	speed = 50
	piercing = 100
	penetration = 1
	damageable_groups = ["player"]
