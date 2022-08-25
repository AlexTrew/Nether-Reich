extends 'res://ui/AbstractUI/AbstractUI.gd'


signal show_game_over_menu

var flintlock_pistol_image = preload("res://pickups/PistolPickup/gun-pickup.png")
var blunderbus_pistol_pickup = preload("res://pickups/BlunderbussPickup/blunderbus.png")
var cannister_cannon_pickup = preload("res://deployables/CannisterCannonDeployable/cannon.png")

#abilities
var empty_ability_image = preload("res://ui/GameUI/ability_slot_empty.png")
var summon_cannon_ability_image = preload("res://ui/GameUI/ability_slot_cannon.png")

#
var summon_cannon_ability_prompt_image = preload("res://ui/GameUI/ability_slot_cannon_prompt.png")

var potion_amount = 100

var map_visible = false


var current_ability_prompt 

var icons_for_pickups = {
	"pistol" : flintlock_pistol_image,
	"blunderbus" : blunderbus_pistol_pickup,
	"cannister_cannon_deployable" : cannister_cannon_pickup,
	"nothing" : null
}


#reorganise these into a cohosive structure for each ability, such as a class
var ability_card_gameui = {
	"no_ability" : empty_ability_image,
	"summon_cannon" : summon_cannon_ability_image
}

var ability_card_prompt = {
	"summon_cannon" : summon_cannon_ability_prompt_image
}

var ability_card_prompt_string = {
	"summon_cannon" : "\"summon demon cannon\""
}

func start():
	pass

func sync_variable_ui_elements():
	update_health(Game.health_ui)
	update_item(Game.held_item_ui)
	update_item_uses(Game.item_uses_ui)

func connect_ui_signals():
	# UI switch signals
	var _b = self.connect('show_game_over_menu', Game, '_on_UI_change_ui_command', ['game_over'])
	var _e = Game.connect('artefact_recovered', self, '_on_Game_artefact_recovered')

	# Player status signals
	var _a = instance_from_id(Game.player_ref_by_id).connect("health_modified", self, "_on_health_modified")
	var _c = instance_from_id(Game.player_ref_by_id).get_node("AbilitySlotComponent").connect("ability_loaded", self, "_on_ability_loaded")
	var _d = instance_from_id(Game.player_ref_by_id).get_node("AbilitySlotComponent").connect("ability_unloaded", self, "_on_ability_unloaded")
	var _f = instance_from_id(Game.player_ref_by_id).get_node("PlayerFSM").get_node("UsingLeftHandItemState").connect("held_item_signal", self, "_on_pickup_item")
	var _g = instance_from_id(Game.player_ref_by_id).connect("reload_progress_modified", self, "_on_receive_reload_progress_modified_signal")
	var _h = $HealingTubeFlashTimer.connect("timeout", self, "_on_health_tube_timer_timeout")

	var _i = $AbilityPickupPromptAnim.connect("animation_finished", self, "_on_ability_prompt_anim_finished")
	var _j = $AbilityPromptDisplayTimer.connect("timeout", self, "_on_ability_prompt_display_timer_timeout")


	instance_from_id(Game.player_ref_by_id).get_node("PlayerFSM").get_node("UsingLeftHandItemState").connect("uses_signal", self, "_on_receive_uses_count")
	instance_from_id(Game.player_ref_by_id).get_node("HealthRestoration").connect("health_restoration_uses_changed", self, "_on_health_restoration_uses_changed")
	instance_from_id(Game.player_ref_by_id).init_ui_signals()

	# Tutorial related signals  - todo: a better way to organise this? These are only required for one level.
	Logger.log(self, "If you see errors about connections, they're fine mate dw.")
	get_node("/root/Level").connect("display_character_signal", self, "_on_receive_display_character_signal")
	get_node("/root/Level").connect("display_text_signal", self, "_on_receive_display_text_signal")
	get_node("/root/Level").connect("undisplay_character_signal", self, "_on_receive_undisplay_character_signal")
	get_node("/root/Level").connect("undisplay_text_signal", self, "_on_receive_undisplay_text_signal")

func _process(_delta):
	if Input.is_action_just_pressed('tab'):
		if !$OnScreenMapUi.visible:
			$OnScreenMapUi.display_map()
		else:
			$OnScreenMapUi.undisplay_map()

	if Input.is_action_just_pressed('ui_cancel'):
		emit_signal('show_game_over_menu')

func _on_Game_artefact_recovered():
	$ArtefactIcon.visible = true


func update_health(health):
	$HealthBar.rect_scale.x = health * 0.2
	Game.health_ui = health


func update_item(item):
	$HeldItemIcon.texture = icons_for_pickups[item]
	Game.held_item_ui = item


func update_item_uses(uses):
	Game.item_uses_ui = uses
	$UsesCount.text = str(uses)
	

func _on_health_modified(health):
	update_health(health)


func _on_pickup_item(item):
	update_item(item)


func _on_receive_uses_count(uses):
	update_item_uses(uses)

func _on_health_restoration_uses_changed(amount_per_cent):
	
	$Liquid.rect_scale.y = amount_per_cent * 0.01
	if(amount_per_cent > potion_amount):
		$HealingTubeFlash.visible = true
		$HealingTubeFlashTimer.start()
	potion_amount = amount_per_cent

func _on_receive_reload_progress_modified_signal(reload_progress_per_cent):
	$ReloadProgress.rect_scale.y = reload_progress_per_cent * 0.01


func _on_health_tube_timer_timeout():
	$HealingTubeFlash.visible = false
##TODO move these signal processing things to GAME.gd... that should sort the UI problems. I don't like it


func display_character():
	$SpeakingCharacter.visible = true

func undisplay_character():
	$SpeakingCharacter.visible = false

func _on_receive_display_character_signal():
	display_character()

func _on_receive_undisplay_character_signal():
	undisplay_character()

func _on_receive_display_text_signal(text):
	$SpeakingCharacterText.visible = true
	$SpeakingCharacterText.bbcode_text = text

func _on_receive_undisplay_text_signal():
	$SpeakingCharacterText.visible = false

func _on_ability_loaded(slot, ability):
	var slot_node

	play_ability_prompt(ability)

	if slot == 1:
		slot_node = $AbilitySlot1
	elif slot == 2:
		slot_node = $AbilitySlot2
	elif slot == 3:
		slot_node = $AbilitySlot3
	elif slot == 4:
		slot_node = $AbilitySlot4
	else:
		return 
	
	slot_node.texture = ability_card_gameui[ability]
	
func _on_ability_unloaded(slot):
	var slot_node

	if slot == 1:
		slot_node = $AbilitySlot1
	elif slot == 2:
		slot_node = $AbilitySlot2
	elif slot == 3:
		slot_node = $AbilitySlot3
	elif slot == 4:
		slot_node = $AbilitySlot4
	else:
		return 
	
	slot_node.texture = ability_card_gameui["no_ability"]


func _on_ability_prompt_anim_finished():
	if $AbilityPickupPromptAnim.animation == "open":
		$AbilityPickupPromptAnim.visible = false
		$AbilityPickupPrompt.visible = true
		$AbilityPromptDisplayTimer.start()

		$AbilityPickupString.visible = true

	if $AbilityPickupPromptAnim.animation == "close":
		$AbilityPickupPromptAnim.visible = false

func _on_ability_prompt_display_timer_timeout():
	$AbilityPickupString.visible = false
	$AbilityPickupPrompt.visible = false
	$AbilityPickupPromptAnim.animation = "close"
	$AbilityPickupPromptAnim.visible = true
	$AbilityPickupPromptAnim.play()


func play_ability_prompt(ability):
	$AbilityPickupString.text = ability_card_prompt_string[ability]
	$AbilityPickupPrompt.texture = ability_card_prompt[ability]
	$AbilityPickupPromptAnim.animation = "open"
	$AbilityPickupPromptAnim.visible = true

	$AbilityPickupPromptAnim.play()
