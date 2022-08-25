extends "res://utils/AbstractFSMState.gd"


var reload_progress
var reload_time = 4

signal reload_progress(progress)


func on_transition_to():
	reload_progress = 0 

func transit():
	if reload_progress > reload_time:
		return "loaded_canister_shot" 
	elif(fsm_owner.get_parent().get_node('PlayerFSM').get_current_state_index() == 'running'):
		return "canister_shot_reloading_interrupted" 

func modify_reload_progress(value):
	reload_progress += value		


func state_process(delta):
	reload_progress += delta
	emit_signal("reload_progress", str(round(reload_progress/reload_time * 100)))

func shoot(shooter, direction):
	# do nothing, as the weapon is empty.
	# todo: play a sound or something
	pass
