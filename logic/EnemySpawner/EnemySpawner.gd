extends Spatial


var waves_to_spawn = 0
var waves_spawned = 0
var max_ranks = 16
# must be square
var wave_size = 0
var target 

var enemy_type
var enemy_types
var enemy_scene
var relative_area
var item_drop_arr = []


func _ready():
	$EditorIconSprite3D.visible = false
	self.add_to_group("spawner")
	var _connect = $SpawnTimer.connect('timeout', self, "on_SpawnTimer_timeout")

	# this may not be the best way to access this, docs say to use shape_owner_get_shape... is this different somehow?
	var spawn_area = $Area/CollisionShape.shape
	relative_area = spawn_area.get_extents().x * spawn_area.get_extents().z


func initialize(enemy_type_id, waves_to_spawn=1):
	enemy_types = {
		"villager": preload("res://enemies/CorruptedVillager/CorruptedVillager.tscn"),
		"rifleman": preload("res://enemies/CorruptedRifleman/CorruptedRifleman.tscn"),
		"swordsman": preload("res://enemies/PosessedSwordsman/PosessedSwordsman.tscn"),
		"hellkite" : preload("res://enemies/HellKite/HellKite.tscn"),
		"headyhandballer" : preload("res://enemies/HeadyHandBaller/HeadyHandBaller.tscn")
	}

	self.enemy_type = enemy_type_id
	self.enemy_scene = enemy_types[enemy_type_id]

	if ProjectSettings.get_setting("netherreich/gameplay/disable_enemies"):
		self.waves_to_spawn = 0

	else:
		self.waves_to_spawn = waves_to_spawn

func set_target():
	target = self.get_parent().get_parent().get_parent().get_node("Player")

func set_wave_size(_wave_size=-1):
	self.wave_size = _wave_size

func spawn_wave(delay=0):
	if !have_all_waves_spawned() && wave_size != 0:
		if(delay>0):
			$SpawnTimer.start(delay)
		else:
			add_spawned_objects_to_tree()

func on_SpawnTimer_timeout():
	if !have_all_waves_spawned():
		add_spawned_objects_to_tree()
		waves_spawned+=1
	else:
		$SpawnTimer.stop()

func add_spawned_objects_to_tree():
	
	var spawn_locations = get_spawn_positions(wave_size, relative_area)

	for location in spawn_locations:
		var enemy = enemy_scene.instance()

		enemy.target = target
		self.get_parent().get_parent().get_parent().add_child(enemy)
		for item in item_drop_arr:
			enemy.add_drop(item)
		
		enemy.global_transform.origin = to_global(location)
		enemy.navigation = get_parent().get_parent().get_parent().get_node('Navigation')
		
	waves_spawned += 1
	Logger.log(self, "spawned %s wave %s of %s" % [self.enemy_type, waves_spawned, waves_to_spawn])

func get_spawn_positions(_wave_size, area):
	
	var area_per_enemy = area/max_ranks
	
	var spawn_locations = []

	var c = 0
	for row in range(max_ranks):
		var x_coord = 0.5 * area_per_enemy + (row * area_per_enemy)
		for column in range(max_ranks):
			var z_coord = 0.5 * area_per_enemy + (column * area_per_enemy)
			if c < _wave_size:
				spawn_locations.append(Vector3(x_coord, 1, z_coord))
				c = c + 1
			else:
				break
	Logger.log(self, "spawn positions calculated: %s" % len(spawn_locations))

	return spawn_locations

func reset_waves_spawned():
	waves_spawned = 0

#add array of items items in format ['item', drop percentage]
func add_item_drops(item_percentage_arr):
	item_drop_arr = item_percentage_arr

func have_all_waves_spawned():
	return waves_spawned >= waves_to_spawn
