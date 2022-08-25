extends "res://utils/AbstractFSMState.gd"



var telegraph_complete
var movement_vector = Vector3(0,0,0)

func _ready():
	$PreAttackingTimer.connect("timeout", self, "_on_preattacking_timer_timeout")
	

func state_process(_delta):
	fsm_owner.look_at(fsm_owner.target.global_transform.origin, Vector3.UP)

func state_physics_process(_delta):
	fsm_owner.motion = movement_vector

func transit():
	var new_state

	if hit:
		new_state = 'RECOILING'
		fsm_owner.get_node("AnimatedSprite").get_node("Eyes").visible = false
	elif telegraph_complete || get_parent().is_at_attacking_distance():
		new_state = 'CHARGING'
	return new_state


func take_hit(value, piercing):
	fsm_owner.take_damage(value, piercing)
	hit = true

	
func on_transition_to():
	fsm_owner.get_node("TelegraphAudioStreamPlayer3D").pitch_scale = rand_range(1,1.2)
	fsm_owner.get_node("TelegraphAudioStreamPlayer3D").play()
	fsm_owner.get_node("AnimatedSprite").get_node("Eyes").visible = true
	fsm_owner.get_node("AnimatedSprite").get_node("Eyes").animation = "preattack"
	hit = false
	telegraph_complete = false
	$PreAttackingTimer.start()

func _on_preattacking_timer_timeout():
	telegraph_complete = true
#add charge timer
