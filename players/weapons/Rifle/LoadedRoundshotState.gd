extends "res://utils/AbstractFSMState.gd"


var bullet_scene = preload("res://players/weapons/Rifle/RifleRoundShot.tscn")
var fired
const shots = 2

signal reloaded


func on_transition_to():
	fsm_owner.get_parent().play_pickup_sound()
	fsm_owner.shots = shots
	self.fired = false
	emit_signal("reloaded")  

func transit():
	if self.fired:
		return "empty_state" 

func state_process(delta):
	pass

func shoot(shooter, direction):
	
	direction.y = 0
	var bullet = bullet_scene.instance()
	shooter.get_parent().add_child(bullet)
	bullet.transform.origin = shooter.transform.origin
	bullet.init(shooter, direction)
	fsm_owner.shots -= 1
	fsm_owner.emit_signal("ammo_count", fsm_owner.shots)
	if fsm_owner.shots == 0:
		self.fired = true
	return true

func modify_auto_reload_progress(progress_delta):
	pass
