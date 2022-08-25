extends 'res://levels/AbstractLevel/AbstractLevel.gd'


var camera_target
var camera 


func connect_level_signals():
	var _player_dead_conn = $Road3/Player.connect("dead", Game, "_on_Player_dead")

func start():
	Game.set_ui('level')
	$Road3.delete_inactive_doors()

	$Road3.set_road_rotation(2)
	$Road3.bake_navmesh_from_template()

	$Road3/Statics/Spawners/EnemySpawner.initialize("hellkite")
	$Road3/Statics/Spawners/EnemySpawner.set_wave_size(1)

	camera = $Camera
	camera_target = $Road3/CameraTarget

	camera.target = camera_target
	camera_target.target = $Road3/Player
