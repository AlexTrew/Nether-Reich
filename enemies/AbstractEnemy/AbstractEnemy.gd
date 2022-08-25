extends KinematicBody

var blood_scene = preload("res://effects/BloodSpray.tscn")
var health_bar_scene = preload("res://ui/Healthbar/Healthbar.tscn")

# the object this enemy wants to move towards, generally the player
var target = null

signal health_modified(new_health) 
signal dead

var drop_item_component = null

# motion to be applied per frame
var motion = Vector3()

var health
var attack_damage

# map from FSM state to sprite animation name
var state_to_animation

# reference to the level's navigation component, for pathfinding
var navigation

# resistance to attacks when not staggered.
var defense 

var health_potion_restore = 10

var injured

var corpse_darkened = false


func _ready():
	self.add_to_group("enemies")
	var __ = $StateMachine.connect("state_transition", self, "_on_state_transition")
	$DamageSpriteModulateTimer.connect("timeout", self, "_on_damage_modulate_timer_timeout")
	spawn_health_bar()

func damage_sprite_modulate():
	$DamageSpriteModulateTimer.start()
	$AnimatedSprite.modulate = "ff0000"
	$AnimatedSprite.shaded = false

func spawn_health_bar():
	var health_bar_instance = health_bar_scene.instance()
	get_parent().add_child(health_bar_instance)
	health_bar_instance.global_transform.basis = get_parent().get_parent().transform.basis 
	health_bar_instance.initialise(self, health)
	connect("health_modified", health_bar_instance, "_on_health_modified")
	connect("dead", health_bar_instance, "_on_dead")
	 

func _process(delta):
	# actions for this tick determined by FSM state
	$StateMachine.state_process(delta)

func _physics_process(delta):
	# actions for this tick determined by FSM state
	$StateMachine.state_physics_process(delta)
	self.move_and_slide_2d(motion)
	
func set_target(_target):
	self.target = _target

func add_item_drop():
	pass

func attack():
	Logger.error(self, 'This function, attack(), is abstract.', true)

func take_damage(_value, _piercing):
	pass

func take_parry():
	pass

func take_block():
	pass

func set_drop_component(drop_component):
	drop_item_component = drop_component
	var room_node = get_parent()
	drop_item_component.set_room(room_node)

func add_drop(item_percentage):
	drop_item_component.add_drop(item_percentage) 

func move_and_slide_2d(_motion):
	$Plane2DMovementHelper.plane_2d_move_and_slide(_motion)

func die():
	blood_spray_spawn()
	#drop_item_component.drop_pickup("powder", 3)
	drop_item_component.drop_pickup("energy")
	drop_item_component.random_drop_pickup()

	if $StateMachine.get_current_state_index() != 'DEAD':
		$StateMachine.set_state("DEAD")

		if(get_node_or_null('AnimatedSprite')):
			$AnimatedSprite.flip_v = randi() % 2
		elif get_node_or_null('SpriteHolder'):
			$SpriteHolder.get_node("AnimatedSprite").flip_v = randi() % 2
		
		emit_signal("dead")
		$CollisionShape.call_deferred("free")
		Logger.log(self, "dead")


func blood_spray_spawn():
	var blood_instance = blood_scene.instance()
	get_parent().add_child(blood_instance)
	blood_instance.transform.origin = self.transform.origin + Vector3(0,1,0)

func get_current_state():
	return $StateMachine.get_current_state_index()

func set_state(state):
	$StateMachine.set_state(state)

func set_animation(animation_index):
	if(get_node_or_null('AnimatedSprite')):
		$AnimatedSprite.play(animation_index)
	elif get_node_or_null('SpriteHolder'):
		$SpriteHolder.get_node("AnimatedSprite").play(animation_index)
	else:
		pass

func modify_aggressiveness(value):
	assert(false)

func send_modify_health_signal(new_health):
	print("new health = " + str(new_health))
	emit_signal("health_modified", new_health)

func _on_death_timer_timeout():
	# disable collision 
	Logger.log(self, "my corpse fades into the ether")
	$CollisionShape.queue_free()

func _on_state_transition(state_index):
	set_animation(state_to_animation[state_index])


func play_damage_sound(sound_id):
	if sound_id:
		$DamageAudioStreamPlayer3D.stream = self.sounds[sound_id]
		$DamageAudioStreamPlayer3D.play()
	else:
		$DamageAudioStreamPlayer3D.stop()


func _on_damage_modulate_timer_timeout():
	$AnimatedSprite.modulate = "ffffff"
	$AnimatedSprite.shaded = true


func subscribe_to_get_simple_path_timer(state):
	var game_obj = get_parent().get_parent().get_parent().get_node("Game")
	var timer = game_obj.get_enemy_get_simple_path_timer_timer()
	timer.connect("timeout", state, "_on_get_simple_path_timer_timeout")


func connect_animated_sprite_signals():
	assert("false", "this function is abstract; implement it")

func _on_death_animation_finished():
	assert("false", "this function is abstract; implement it")

func darken_sprite():
	assert("false", "this function is abstract; implement it")
