extends "res://utils/AbstractFSMState.gd"


const SPEED = 0
var path


func state_process(_delta):
	if fsm_owner.target:
		self.fsm_owner.get_node('SpriteHolder').look_at(fsm_owner.target.global_transform.origin, Vector3.UP)
		self.path = self.fsm_owner.navigation.get_simple_path(fsm_owner.transform.origin, fsm_owner.target.transform.origin)
	else:
		self.path = []

	# draw_path()

func state_physics_process(_delta):
	fsm_owner.motion = Vector3(0, 0, 0)

func transit():
	pass

func on_transition_to():
	pass

func draw_path():
	# some debug visualisation
	for indicator in get_tree().get_nodes_in_group("indicators"):
		indicator.free()

	for point in self.path:
		var indicator = MeshInstance.new()
		indicator.mesh = preload("res://utils/NavmeshVisualisationPoint/NavmeshVisPoint.tres")
		indicator.global_transform.origin = point
		indicator.add_to_group("indicators")
		fsm_owner.get_parent().add_child(indicator)
