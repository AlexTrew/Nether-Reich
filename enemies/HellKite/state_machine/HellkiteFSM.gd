extends "res://utils/AbstractFSM.gd"

var FLANKING_START_DISTANCE = 12
var FLANKING_END_DISTANCE = 15
var CHARGING_DISTANCE = 7
var ATTACK_DISTANCE = 1


func _ready():
	state_objects = {
		'IDLE': $IdleState,
		'ADVANCING': $AdvancingState,
		'RETREATING': $RetreatingState,
		'FLANKING': $FlankingState,
		'ATTACKING': $AttackState,
		'DEAD': $DeadState
	}




func is_at_flanking_distance():
	return (get_parent().global_transform.origin - get_parent().target.global_transform.origin).length() < FLANKING_START_DISTANCE - randi() % 30

	
func has_left_flanking_distance():
	return (get_parent().global_transform.origin - get_parent().target.global_transform.origin).length() > FLANKING_END_DISTANCE


func is_at_charging_distance():
	return (get_parent().global_transform.origin - get_parent().target.global_transform.origin).length() < CHARGING_DISTANCE


func is_at_attacking_distance():
	return (get_parent().global_transform.origin - get_parent().target.global_transform.origin).length() < ATTACK_DISTANCE


func is_dead():
	return get_parent().dead
