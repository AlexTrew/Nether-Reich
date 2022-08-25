extends "res://utils/AbstractFSM.gd"


var FLANKING_END_DISTANCE = 8
var FLANKING_START_DISTANCE = 1
var CHARGING_DISTANCE = 8
var ATTACK_DISTANCE = 2.0


func _ready():
	state_objects = {
		'IDLE': $IdleState,
		'ADVANCING': $AdvancingState,
		'FLANKING': $FlankingState,
		'FLANKINGBLOCKING': $FlankingStateBlocking,
		'CHARGING': $ChargingState,
		'ATTACKING': $AttackingState,
		'PREATTACKING': $PreAttackingState,
		'FAINTATTACKING': $FaintAttackingState,
		'DEFENDING': $DefendingState,
		'RECOILING': $RecoilingState,
		'STUNNED': $StunnedState,
		'ATTACKRECOVER' : $AttackRecoverState,
		'SIDESTEP' : $SidestepState,
		'DEAD': $DeadState
	}

func is_at_flanking_distance():
	return (get_parent().global_transform.origin - get_parent().target.global_transform.origin).length() < FLANKING_END_DISTANCE

func closer_than_flanking_distance():
	return (get_parent().global_transform.origin - get_parent().target.global_transform.origin).length() < FLANKING_START_DISTANCE

func has_left_flanking_distance():
	return (get_parent().global_transform.origin - get_parent().target.global_transform.origin).length() > FLANKING_END_DISTANCE + 3

func is_at_charging_distance():
	return (get_parent().global_transform.origin - get_parent().target.global_transform.origin).length() < CHARGING_DISTANCE

func is_at_attacking_distance():
	return (get_parent().global_transform.origin - get_parent().target.global_transform.origin).length() < ATTACK_DISTANCE

func is_dead():
	return get_parent().dead

func set_aggressiveness():
	pass

func set_aggressiveness_mod(value):
	self.state_objects[get_current_state_index()].set_aggressiveness_mod(value)
