extends Node


var health_ui
var held_item_ui = "nothing"
var item_uses_ui = ""

signal map_grid_signal(grid)
var grid

var player_ref_by_id


var current_level_id
var level_scenes = {
	"level_select" : 'res://levels/LevelSelect/LevelSelect.tscn',
	"tile_test" : 'res://levels/TileTestLevel/TileTestLevel.tscn',
	"level_gen_test" : 'res://levels/RNGhaltLevel/RNGhaltLevel.tscn',
	"tutorial" : 'res://levels/TutorialLevel/TutorialLevel.tscn',
	"null" : 'res://levels/NullLevel/NullLevel.tscn'
}

var current_ui_id
var ui_scenes = {
	"main_menu": 'res://ui/LevelSelectMenuUI/LevelSelectMenuUI.tscn',
	"level": 'res://ui/GameUI/GameUI.tscn',
	"game_over": 'res://ui/GameOverMenuUI/GameOverMenuUI.tscn',
	"level_complete": 'res://ui/LevelCompleteMenuUI/LevelCompleteMenuUI.tscn',
}

# deprecated
var current_camera_id
var cameras = {
	"player": "Camera",
	"map": "MapCamera" 
}


signal artefact_recovered


func set_level(level_id):
	# swap out existing Level node for the new level
	Logger.log(self, 'setting level to %s' % level_id)
	if level_id in level_scenes.keys():
		self.grid = null
		get_tree().change_scene(level_scenes[level_id])
		self.current_level_id = level_id
	else:
		Logger.error(self, "Failed to change level to %s, no such level." % level_id)

func get_level_id():
	return self.current_level_id

func set_ui(ui_id):
	Logger.log(self, "setting UI to %s" % ui_id)
	var ui_instance = load(self.ui_scenes[ui_id]).instance()
	self.clear_ui()
	ui_instance.set_name("UI")
	get_parent().call_deferred("add_child", ui_instance)

func clear_ui():
	if get_parent().get_node_or_null('UI'):
		var old_ui = get_parent().get_node("UI")
		get_parent().remove_child(old_ui)
		old_ui.queue_free()

# probably deprecated
func set_camera(camera_id):
	Logger.log(self, "setting camera to %s" % camera_id)
	$Level.get_node(self.cameras[camera_id]).current = true
	self.current_camera_id = camera_id

# probably deprecated
func get_camera_id():
	return self.current_camera_id

func _on_Player_dead():
	self.set_ui("game_over")

func _on_Level_Artefact_recovered():
	self.get_node("/root/Level").reset_enemies()

func _on_Level_Player_at_spawn(player):
	if player.has_artefact:
		self.set_ui("level_complete")

func _on_Level_LevelDoor_activated(level_id):
	self.set_level(level_id)

func _on_Level_grid_generated(grid):
	Logger.log(self, "Received grid from level")
	self.grid = grid
	emit_signal("map_grid_signal", grid)

func _on_UI_change_level_command(level_id):
	self.set_level(level_id)

func _on_UI_regenerate_level_command():
	self.get_node("/root/Level").regenerate_level_tiles()

func _on_UI_change_ui_command(ui_id):
	self.set_ui(ui_id)

func _on_UI_switch_camera_command(camera_id):
	self.set_camera(camera_id)

func _on_UI_exit_to_menu_command():
	self.set_level("level_select")

func _on_UI_exit_game_command():
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)

func get_enemy_get_simple_path_timer_timer():
	return $EnemyGetSimplePathTimer
