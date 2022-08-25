extends Spatial


var damage = 150

var speed = 40

# armour piercing
var piercing = 100

var direction = Vector3(0,0, 0)

var motion = Vector3(0,0,0)

# the character from which the shot originated. shots cannot damage the shooter
var shooter

# groups which the shot can damage. if empty, the shot will damage all bodies regardless of group
var damageable_groups = []

# groups which stop the bullet regardless of remaining penetration. Bodies in this group are not necessarily undamageable.
var impenetrable_groups = ["statics"]

# bodies which have already been checked
var checked_bodies = []

# destory shot after this many bodies are damaged
var penetration = 1


func _process(delta):
	check_impact()
	$Plane2DMovementHelper.plane_2d_move(direction, speed, delta)
	
func init(_shooter, _direction):
	self.shooter = _shooter 	
	self.direction = _direction 	

func apply_damage(body):
	body.take_damage(self.damage, self.piercing)
	

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

		if self.penetration <= 0:
			self.queue_free()

