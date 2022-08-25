extends "res://utils/AbstractFSMState.gd"

var attack_cooldown_complete = false
var attack_complete = false

const SPEED = 0
const attack_cooldown_time = 0.5


func _ready():
	var __ = $AttackCooldownTimer.connect("timeout", self, "_on_AttackCooldownTimer_timeout")
	
func on_transition_to():
	fsm_owner.get_node("AnimatedSprite").get_node("Eyes").animation = "attacking"
	hit = false
	attack_complete = false
	attack_cooldown_complete = false
	$AttackCooldownTimer.start(attack_cooldown_time)

func transit():
	var new_state 

	if hit:
		fsm_owner.get_node("AnimatedSprite").get_node("Eyes").visible = false
		new_state = 'RECOILING'
	elif attack_cooldown_complete:
		fsm_owner.get_node("AnimatedSprite").get_node("Eyes").visible = false
		new_state = 'ADVANCING'
	
	return new_state

func state_process(_delta):
	pass


func take_hit(value, piercing):
	fsm_owner.take_damage(value, piercing)
	hit = true


func state_physics_process(_delta):
	fsm_owner.motion = Vector3(0, 0, 0)

	# we only want to do damage for one frame of being in this state, then wait for the cooldown to elapse.
	if !attack_complete:
		fsm_owner.attack()
		attack_complete = true

func _on_AttackCooldownTimer_timeout():
	attack_cooldown_complete = true
