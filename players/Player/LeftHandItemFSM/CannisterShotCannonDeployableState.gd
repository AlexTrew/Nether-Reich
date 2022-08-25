extends "res://utils/AbstractFSMState.gd"

var placed 

var shots = 1

var fuse_time = 3


signal ammo_count(shots)

var cannon_scene = preload("res://deployables/CannisterCannonDeployable/CannisterShotCannonDeployable.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("ammo_count", get_parent().get_parent(), "_on_receive_uses_count")
	emit_signal("ammo_count", shots)
	fsm_owner = self.get_parent().get_parent().get_parent().get_parent()


func on_transition_to():
	if !placed:
		var cannon_instance = cannon_scene.instance()
		fsm_owner.get_parent().add_child(cannon_instance)
		cannon_instance.transform = fsm_owner.transform
		cannon_instance.init(fuse_time, fsm_owner)
		shots -= 1
		placed = true
		emit_signal("ammo_count", shots)


func transit():
	if placed:
		return 'done'


func state_process(_delta):
	pass


func state_physics_process(_delta):
	fsm_owner.get_node("PlayerTranslationComponent").movement()


func send_item_uses_signal():
	emit_signal("ammo_count", shots)
