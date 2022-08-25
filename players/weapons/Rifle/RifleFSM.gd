extends "res://utils/AbstractFSM.gd"


func _ready():
	state_objects = {
		"loaded_round_shot": $LoadedRoundShotState,
		"loaded_canister_shot": $LoadedCanisterShotState,
		"loading_round_shot": $LoadingRoundShotState,
		"loading_canister_shot": $LoadingCanisterShotState,
		"round_shot_reloading_interrupted": $RSReloadingInterruptedState,
		"canister_shot_reloading_interrupted": $CSReloadingInterruptedState,
		"empty_state": $EmptyState
	}

func modify_auto_reload_progress(progress_delta):
	current_state.modify_auto_reload_progress(progress_delta)