extends "res://utils/AbstractFSMState.gd"

const shots = 0

signal reload_progress_ui(reload_progress)

var auto_reload_progress
var auto_reload_progress_limit

func _ready():
	auto_reload_progress_limit = 100 
	connect("reload_progress_ui", self.fsm_owner.get_parent(), "_on_reload_progress_signal_received")

func on_transition_to():
	auto_reload_progress = 0
	emit_signal("reload_progress_ui", auto_reload_progress)
	fsm_owner.shots = shots

func transit():
	
	if auto_reload_progress >= auto_reload_progress_limit:
		if fsm_owner.get_parent().held_item == 'pistol':
			return "loaded_round_shot"
		elif fsm_owner.get_parent().held_item == 'blunderbus':
			return "loaded_canister_shot"


func state_process(_delta):
	pass


func modify_auto_reload_progress(progress_delta):
	auto_reload_progress += progress_delta
	if auto_reload_progress <= auto_reload_progress_limit:
		emit_signal("reload_progress_ui", auto_reload_progress)


func shoot(shooter, direction):
	# do nothing, as the weapon is empty.
	# todo: play a sound or something
	return false
