extends "res://utils/AbstractFSMState.gd"

var reload_time_mod = 1 #add time to reload time

func on_transition_to():
	pass

func transit():
	if(fsm_owner.get_parent().get_node('PlayerFSM').get_current_state_index() == 'walking'):
		self.get_parent().get_node('LoadingRoundShotState').modify_reload_progress(reload_time_mod)
		return "loading_round_shot" 

func state_process(_delta):
	pass

func shoot(shooter, direction):
	# do nothing, as the weapon is empty.
	# todo: play a sound or something
	return false