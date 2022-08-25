extends Node


# node of room
var room_node 

var blunderbus_pickup_object = preload("res://pickups/BlunderbussPickup/PickupBlunderbus.tscn")
var pistol_pickup_object = preload("res://pickups/PistolPickup/PickupPistol.tscn")
var cannister_cannon_deployable_object = preload("res://pickups/CannisterCannonPickup/CannisterCannonPickup.tscn")
var energy_pickup_object = preload("res://pickups/EnergyPickup/EnergyPickup.tscn")
var large_energy_pickup_object = preload("res://pickups/EnergyPickup/LargeEnergyPickup.tscn")
var powder_pickup_object = preload("res://pickups/PowderPickup/PowderPickup.tscn")

var drop_objects = {}

#percentage chance of items to drop list of { item : percentage}
var drop_percentages = []

func _ready():
	drop_objects = {
		'energy' : energy_pickup_object,
		'large_energy' : large_energy_pickup_object,
		'blunderbus' : blunderbus_pickup_object,
		'pistol' : pistol_pickup_object,
		'cannister_cannon_deployable' : cannister_cannon_deployable_object,
		'powder' : powder_pickup_object
	}


func add_drop(item_percentage):
	if len(item_percentage) != 2:
		assert(false, "item to percentage array for initalising drop must be of length 2!")
	else:
		drop_percentages.append(item_percentage)


func random_drop_pickup():
	var smallest_n = INF
	var index_of_smallest_n = -1
	for i in range(len(drop_percentages)):
		var n = randi() % 100
		if n <= drop_percentages[i][1]:
			if n < smallest_n:
				smallest_n = n
				index_of_smallest_n = i


	if index_of_smallest_n != -1:
		#spawn the drop
		
		drop_pickup(drop_percentages[index_of_smallest_n][0])

func drop_pickup(drop, quantity=1):
	for pickup in range(quantity):
		var item_scene = drop_objects[drop]
		var drop_instance = item_scene.instance()
		room_node.add_child(drop_instance)
		drop_instance.global_transform.origin = Vector3(self.get_parent().global_transform.origin.x, 1, self.get_parent().global_transform.origin.z)
		Logger.log(self, "item dropped at " + str(self.get_parent().global_transform.origin.x) + ", " +  str(self.get_parent().global_transform.origin.z) )
		

func set_room(_room_node):
	self.room_node = _room_node
