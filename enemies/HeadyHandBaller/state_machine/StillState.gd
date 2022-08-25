extends "res://utils/AbstractFSMState.gd"


const SPEED = 0

var done_resting
var ready_to_shoot = false
var shots 
var fired = 0


var projectile = preload("res://enemies/HeadyHandBaller/HeadyHandBallerProjectile.tscn")

func _ready():
	$StillTimer.connect("timeout", self, "_on_still_timer_timeout")
	$ProjectileSeparationTimer.connect("timeout", self, "_on_projectile_separation_timer_timeout")

func state_process(_delta):
	fsm_owner.get_node("SpriteHolder").look_at(fsm_owner.target.global_transform.origin, Vector3.UP)
	
	if ready_to_shoot && fired < shots:
		shoot()
		ready_to_shoot = false
		$ProjectileSeparationTimer.start()
	
	
func state_physics_process(_delta):
	fsm_owner.motion = Vector3(0, 0, 0)

func transit():
	var new_state

	if done_resting:
		new_state = "ROAMING"
		fired = 0
	return new_state


func take_hit(value, piercing):
	fsm_owner.take_damage(value, piercing)
		


func on_transition_to():
	done_resting = false
	randomize()
	shots = rand_range(10,15)
	$ProjectileSeparationTimer.wait_time = 0.04
	$StillTimer.wait_time = rand_range(1, 2.3)
	$StillTimer.start()
	$ProjectileSeparationTimer.start()
	

func shoot():
	var shot_part = projectile.instance()
	fsm_owner.get_parent().add_child(shot_part)
	shot_part.global_transform.origin = fsm_owner.get_node("SpriteHolder").global_transform.origin
	if fired == 0:
		fsm_owner.play_vomit_sound()
		shot_part.set_first(true)
	shot_part.init(fsm_owner, (fsm_owner.target.global_transform.origin - fsm_owner.global_transform.origin).normalized())
	fired += 1

func _on_still_timer_timeout():
	done_resting = true

func _on_projectile_separation_timer_timeout():
	ready_to_shoot = true
