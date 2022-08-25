extends "res://utils/AbstractFSM.gd"


func _ready():
	state_objects = {
		'draw_pistol': $DrawPistolState,
		'aim_pistol': $AimPistolState,
		'holster_pistol': $HolsterPistolState,
		'cannister_cannon_deployable' : $CannisterShotCannonDeployableState,
		'done': $DoneState,
	}

#i hate this
func initialise_item_uses_ui_non_firearm_item():
	if get_parent().fsm_owner.held_item == 'cannister_cannon_deployable':
		$CannisterShotCannonDeployableState.send_item_uses_signal()
