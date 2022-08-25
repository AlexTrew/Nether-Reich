extends "res://pickups/AbstractPickup/AbstractPickup.gd"


func _ready():
	can_be_picked_up_by_groups = ['player']
	can_be_picked_up = true


func _on_body_entered(body):
	if can_be_picked_up and Utils.is_node_in_group_in_grouplist(body, self.can_be_picked_up_by_groups):
		if body.get_node("HealthRestoration").percent_full < body.get_node("HealthRestoration").MAX_PERCENT:
			self.on_pickup(body)


func on_pickup(picker_upper):
	picker_upper.recharge_healh_resoration(100)
	picker_upper.play_energy_pickup_sound()
	queue_free()
