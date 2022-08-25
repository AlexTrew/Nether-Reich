extends "res://utils/AbstractFSMState.gd"

var attack_cooldown_complete = false
var attack_complete = false

const SPEED = 0
const attack_cooldown_time = 0.1


func _ready():
	var __ = $AttackCooldownTimer.connect("timeout", self, "_on_AttackCooldownTimer_timeout")
	hit = false
	
func on_transition_to():
	fsm_owner.get_node("AnimatedSpriteLegs").animation = "lunge"
	hit = false
	fsm_owner.play_footstep_sound(null)
	attack_complete = false
	attack_cooldown_complete = false
	$AttackCooldownTimer.start(attack_cooldown_time)

func transit():
	var new_state 

	if hit:
		new_state = 'RECOILING'

	elif attack_cooldown_complete:
		new_state = 'ATTACKRECOVER'
	
	return new_state

func state_process(_delta):
	pass


func take_hit(damage, piercing):
	fsm_owner.take_damage(damage, piercing)
	hit = true


func state_physics_process(_delta):
	fsm_owner.motion = Vector3(0, 0, 0)

	# we only want to do damage for one frame of being in this state, then wait for the cooldown to elapse.
	if !attack_complete:
		fsm_owner.attack()
		attack_complete = true

func _on_AttackCooldownTimer_timeout():
	attack_cooldown_complete = true

func set_aggressiveness_mod(value):
	pass
