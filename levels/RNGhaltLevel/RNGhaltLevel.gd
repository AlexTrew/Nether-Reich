extends 'res://levels/AbstractLevel/AbstractLevel.gd'


var camera_target
var camera

signal grid_generated(grid)

var main_path_rooms = []
var audio_tracks_randomize_arr = []


func connect_level_signals():
	var _grid_gen_c = self.connect("grid_generated", Game, "_on_Level_grid_generated")

func start():
	Game.set_ui('level')
	self.regenerate_level_tiles()
	emit_signal("grid_generated", $LevelGeneratorComponent.grid)
	
	$LevelGeneratorComponent.queue_free()

	if ProjectSettings.get_setting("netherreich/audio/disable_music"):
		Logger.log(self, "music is disabled")
	else:
		var track_index = randi() % len(audio_tracks_randomize_arr)
		$MusicAudioStreamPlayer.stream = audio_tracks_randomize_arr[track_index]
		$MusicAudioStreamPlayer.play()

func regenerate_level_tiles():
	self._clear_level_tiles()
	$LevelGeneratorComponent.generate_map(5)
	$LevelGeneratorComponent.populate_rooms_with_enemies(3)
	main_path_rooms = $LevelGeneratorComponent.main_path_rooms
	
	camera = $Camera
	camera_target = $StartRoom/CameraTarget

	camera.target = camera_target
	camera_target.target = $StartRoom/Player


func kill_enemies():
	var enemy_counter = 0
	var tiles = _get_level_tiles()
	for tile in tiles:
		enemy_counter += tile.kill_enemies()
	return {"enemies_killed": enemy_counter, "across_tiles": len(tiles)}


func _clear_level_tiles():
	for tile in self._get_level_tiles():
		tile.queue_free()

func _get_level_tiles():
	var tiles = []
	for child in get_children():
		if child.is_in_group('level_tiles'):
			tiles.append(child)
	return tiles

# deprecated
func _player_entered_camera_trigger_x_lock(lock_position):
	camera_target.set_lock_type("locked_x", lock_position)

# deprecated
func _player_entered_camera_trigger_z_lock(lock_position):
	camera_target.set_lock_type("locked_z", lock_position)

# deprecated
func _player_entered_camera_trigger_no_lock(lock_position):
	camera_target.set_lock_type("none", lock_position)


