extends Spatial


func _ready():
	var room_node = get_parent().get_parent()
	$DropItemComponent.set_room(room_node)

func add_drop(item_percentage):
	$DropItemComponent.add_drop(item_percentage)


func random_drop_pickup():
	$DropItemComponent.random_drop_pickup()


func drop_pickup(drop, quantity=1):
	$DropItemComponent.drop_pickup(drop, quantity)