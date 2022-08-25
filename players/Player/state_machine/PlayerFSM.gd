extends "res://utils/AbstractFSM.gd"


func _ready():
	state_objects = {
		'running': $RunningState,
		'using_left_hand_item': $UsingLeftHandItemState,
		'attacking': $SwordAttackingState,
		'parrying': $SwordParryingState,
		'reloading': $ReloadingState,	
		'blocking' : $BlockingState,
		'sidestep': $SidestepState,
		'staggered' : $StaggeredState,
		'dead': $DeadState
	}


func set_left_hand_item(item):
	$UsingLeftHandItemState.set_left_hand_item(item)

func get_left_hand_item():
	return $UsingLeftHandItemState.get_left_hand_item()
