extends "res://utils/AbstractFSM.gd"



func _ready():
	state_objects = {
		'IDLE': $IdleState,
		'ROAMING': $RoamingState,
		'STILL' : $StillState,
		'ATTACKING': $AttackingState,
		'RECOILING': $RecoilingState,
		'STUNNED': $StunnedState,
		'DEAD': $DeadState
	}


func set_animation(animation_index):
	if(get_node_or_null('AnimatedSprite')):
		$AnimatedSprite.play(animation_index)
	else:
		pass