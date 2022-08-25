extends "res://utils/AbstractShot.gd"

func _ready():

	$LifeTimer.connect("timeout", self, "_on_life_timer_timeout")
	damage = 2
	speed = 8
	piercing = 100
	penetration = 1
	damageable_groups = ["player"]
	$LifeTimer.start()



func check_impact():
	for body in $Area.get_overlapping_bodies():

		# ensure we don't waste time checking bodies twice
		if body in self.checked_bodies:
			return false

		self.checked_bodies.append(body)

		if body == shooter:
			return false

		if (len(damageable_groups) && Utils.is_node_in_group_in_grouplist(body, damageable_groups)) || !len(damageable_groups):
			self.apply_damage(body)
			self.penetration -= 1

		if Utils.is_node_in_group_in_grouplist(body, impenetrable_groups):
			self.penetration = 0


func _on_life_timer_timeout():
	queue_free()
