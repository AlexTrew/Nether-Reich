extends Area


var can_be_picked_up = true


# members of any group in this list can pick up the item
var can_be_picked_up_by_groups = []


func _ready():
	var __ = self.connect('body_entered', self, '_on_body_entered')
	

func _on_body_entered(body):
	if can_be_picked_up and Utils.is_node_in_group_in_grouplist(body, self.can_be_picked_up_by_groups):
		self.on_pickup(body)

		
func on_pickup(picker_upper):
	Logger.error(self, "Subclasses should implement this abstract method")
