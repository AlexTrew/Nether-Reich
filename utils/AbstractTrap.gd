extends Spatial

var damageable_groups = []
var checked_bodies = []
var damage = 0
var piercing 

func _process(delta):
	check_impact()

func check_impact():
	for body in $Area.get_overlapping_bodies():

		# ensure we don't waste time checking bodies twice
		if body in self.checked_bodies:
			return false

		self.checked_bodies.append(body)

		if (len(damageable_groups) && Utils.is_node_in_group_in_grouplist(body, damageable_groups)) || !len(damageable_groups):
			self.apply_damage(body)


func body_in_group_in_list(body, group_list):
	for group in group_list:
		if body.is_in_group(group):
			return true
	
	return false


func apply_damage(body):
	body.take_damage(self.damage, self.piercing)
