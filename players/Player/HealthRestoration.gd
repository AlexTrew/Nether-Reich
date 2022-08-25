extends Node

var percent_full
var heal_cost = 40
var heal_amount = 3
var MAX_PERCENT = 100

signal health_restoration_uses_changed(amount_per_cent)

# Called when the node enters the scene tree for the first time.
func _ready():
	percent_full = 100


func get_heal_amount():
	if percent_full >= heal_cost:
		percent_full -= heal_cost
		emit_signal("health_restoration_uses_changed", percent_full)
		get_parent().get_node("HealthRestorationStreamPlayer3D").play()
		return heal_amount
	else:
		return 0


func recharge_healh_resoration(amount):
	percent_full += amount
	if percent_full > MAX_PERCENT:
		percent_full = MAX_PERCENT

	emit_signal("health_restoration_uses_changed", percent_full)
	
	
