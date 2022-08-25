extends Node


signal firearm_empty
signal ammo_count(shots)
signal firearm_reloading(ammo_type)
signal firearm_loaded(ammo_type)

var musket_smoke_scene = preload("res://effects/MusketSmokeEffect.tscn")
var shots = 0

func _ready():
	var _rifle_state_conn = $RifleFSM.connect("state_transition", self, "_on_RifleFSM_state_transition")
	var _muzzle_flash_conn = $MuzzleFlashTimer.connect("timeout", self, "on_MuzzleFlashTimer_timeout")
	self.connect("ammo_count", get_parent().get_node("PlayerFSM").get_node("UsingLeftHandItemState"), "_on_receive_uses_count")

	# comes loaded with round shot
	$RifleFSM.set_state("empty_state")

func _process(delta):
	$RifleFSM.state_process(delta)

func shoot(shooter, direction):
	$ReloadAudioStreamPlayer2D.stop()

	# not a fan of this
	if $RifleFSM.current_state.shoot(shooter, direction):
		$FireAudioStreamPlayer2D.play()
		get_parent().emit_signal("firing")
		var musket_smoke = musket_smoke_scene.instance()
		self.get_parent().get_parent().add_child(musket_smoke)
		musket_smoke.global_transform.origin = shooter.global_transform.origin + Vector3(0,0.1,0)
	else:
		$RifleEmptyClickAudioStreamPlayer.play()

func load(ammo_type):
	# also not a fan of this
	if !"loading" in $RifleFSM.get_current_state_index():
		match ammo_type:
			"round_shot":
				$RifleFSM.set_state("loading_round_shot")
			"canister_shot":
				$RifleFSM.set_state("loading_canister_shot")
		
		$ReloadAudioStreamPlayer2D.play()

func _on_RifleFSM_state_transition(new_state):
	# emit signals when the state of the rifle changes, e.g for updating UI

	match new_state:
		"loaded_round_shot": 
			emit_signal("firearm_loaded", "round_shot")
			emit_signal("ammo_count", shots)
		"loaded_canister_shot": 
			emit_signal("firearm_loaded", "canister_shot")
			emit_signal("ammo_count", shots)
		"loading_round_shot": 
			emit_signal("firearm_reloading", "round_shot")
		"loading_canister_shot": 
			emit_signal("firearm_reloading", "canister_shot")
		"empty_state": 
			emit_signal("firearm_empty")
			emit_signal("ammo_count", shots)

func on_MuzzleFlashTimer_timeout():
	$MuzzleFlashLight2D.enabled = false

func modify_auto_reload_progress(progress_delta):
	$RifleFSM.modify_auto_reload_progress(progress_delta)
