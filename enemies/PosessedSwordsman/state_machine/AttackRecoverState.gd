extends "res://utils/AbstractFSMState.gd"

var recover_complete

# Called when the node enters the scene tree for the first time.
func _ready():
	var __ = $AttackCooldownTimer.connect("timeout", self, "_on_AttackCooldownTimer_timeout")

func set_aggressiveness_mod(mod):
	pass

func state_process(_delta):
	fsm_owner.motion = Vector3(0, 0, 0)

func state_physics_process(_delta):
	pass 

func on_transition_to():
	fsm_owner.get_node("AnimatedSpriteLegs").animation = "lunge"
	hit = false
	fsm_owner.play_footstep_sound(null)
	recover_complete = false
	$AttackCooldownTimer.start()

func transit():
	var new_state 

	if hit:
		new_state = 'RECOILING'

	elif recover_complete:
		new_state = 'ADVANCING'
	
	return new_state


func take_hit(value, piercing):
	fsm_owner.take_damage(value, piercing)
	hit = true


func _on_AttackCooldownTimer_timeout():
	recover_complete = true