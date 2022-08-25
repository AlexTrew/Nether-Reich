extends "res://utils/AbstractStatic.gd"

var material1 = load("res://statics/HighHouse/Materials/HighHouseStatic1.tres")
var material2 = load("res://statics/HighHouse/Materials/HighHouseStatic2.tres")
var material3 = load("res://statics/HighHouse/Materials/HighHouseStatic3.tres")

var materials = [material1, material2, material3]


func _ready():
	var random_material = materials[randi() % len(materials)]
	print(str(random_material))
	self.get_node("Cube").mesh.surface_set_material(0, random_material)
