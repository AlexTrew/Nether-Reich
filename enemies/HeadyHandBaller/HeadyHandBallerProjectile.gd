extends "res://utils/AbstractShot.gd"

var first = false

var splat_scene = preload("res://enemies/HeadyHandBaller/HeadyHandBallerProjectileSplat.tscn")

func _ready():

	$LifeTimer.connect("timeout", self, "_on_life_timer_timeout")
	damage = 5
	speed = 8
	piercing = 100
	penetration = 1
	damageable_groups = ["player"]
	$LifeTimer.start()

	
func set_first(b):
	first = b


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
	if first:
		var splat = splat_scene.instance()
		get_parent().add_child(splat)
		splat.global_transform.origin = self.global_transform.origin + Vector3(0, -0.9, 0)
	queue_free()
