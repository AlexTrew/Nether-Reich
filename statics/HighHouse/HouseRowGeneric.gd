extends Spatial





# Called when the node enters the scene tree for the first time.
func _ready():
	var child_count = get_child_count()
	var index = randi() % child_count

	for i in range(0, child_count):
		if i == index:
			get_child(i).visible = true
		else:
			get_child(i).visible = false
