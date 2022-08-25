extends "res://utils/AbstractFSMState.gd"


var bullet_scene = preload("res://players/weapons/Rifle/RifleCanisterShot.tscn")
var number_of_pellets = 7
var spread = deg2rad(45)
var fired

const shots = 1

signal reloaded


func on_transition_to():
	fsm_owner.get_parent().play_pickup_sound()
	fsm_owner.shots = shots
	self.fired = false
	emit_signal("reloaded") 

func transit():
	if self.fired:
		return "empty_state"

func state_process(_delta):
	pass

func shoot(shooter, direction):

	direction.y = 0
	var initial_pellet_direction = direction.rotated(Vector3.UP, -spread / 2)
	var pellet_delta_direction = spread / number_of_pellets

	for n in range(number_of_pellets):
		var bullet = bullet_scene.instance()
		shooter.get_parent().add_child(bullet)
		bullet.transform.origin = shooter.transform.origin
		var pellet_direction = initial_pellet_direction.rotated(Vector3.UP, n * pellet_delta_direction)
		bullet.init(shooter, pellet_direction)
	fsm_owner.shots -= 1
	fsm_owner.emit_signal("ammo_count", fsm_owner.shots)
	if fsm_owner.shots == 0:
		self.fired = true
	return true

func modify_auto_reload_progress(progress_delta):
	pass