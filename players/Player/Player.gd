extends KinematicBody
class_name Player


var motion = Vector3()
var starting_health = 10
var health = starting_health
var state_to_animation
var has_artefact = false
var dodge_ready = true
var blocking = false
var invulnerable = false
var can_control

var camera 

var held_item
var item_uses 

var lantern_in_right_hand 

var lantern_scene = preload("res://players/Player/Lantern/Lantern.tscn")

var lantern_instance

#put these sounds in the right place!
var sounds = {
	"walking": preload("res://enemies/PosessedSwordsman/assets/Netherreich_Footstep_Walking_Concrete.wav"),
	"running": preload("res://enemies/PosessedSwordsman/assets/Netherreich_Footstep_Running_Grass_1.wav"),
	"sprinting": preload("res://enemies/PosessedSwordsman/assets/Netherreich_Footstep_Sprinting_Grass_1.wav"),
	"injured" : preload("res://players/Player/Sounds/injured_oof.wav"),
	"dead" : preload("res://players/Player/Sounds/death_scream.wav")
}

signal health_modified(health)
signal reload_progress_modified(reload_progress)
signal damaged
signal dead
signal explosion
signal firing


func _init():
	state_to_animation = {
		'running': 'move',
		'using_left_hand_item': 'idle',
		'attacking': 'stab',
		'blocking': 'blocking',
		'parrying': 'idle',
		'reloading': 'reload',
		'sidestep': 'idle',
		'staggered' : 'staggered',
		'dead': 'dead',
	}

func _ready():
	$HeldWeaponSprite.visible = false
	$LanternModel.visible = true
	lantern_in_right_hand = true
	$DropItemComponent.set_room(get_parent())
	can_control = true
	Game.player_ref_by_id = self.get_instance_id()
	camera = get_parent().get_parent().get_node("Camera")
	self.add_to_group("player")
	var __ = $PlayerFSM.connect("state_transition", self, "_on_PlayerFSM_state_transition")

	item_uses = 0

	$IFrameTimer.connect("timeout", self, "_on_IFrame_timeout")
	$PlayerFSM.get_node('UsingLeftHandItemState').get_node('LeftHandItemFSM').connect("state_transition", self, "_on_LeftHandItemFSM_state_transition")
	self.connect("damaged", camera, "_on_receive_player_damage_signal")
	self.connect("firing", camera, "_on_receive_player_firing_signal")
	self.connect("health_modified", get_parent().get_parent().get_parent(), "_on_health_modified")
	self.connect("explosion", camera, "_on_receive_explosion_signal")

	$PlayerFSM/UsingLeftHandItemState.connect("held_item_signal", self, "_on_receive_held_item_signal")
	$PlayerFSM/UsingLeftHandItemState.connect("uses_signal", self, "_on_item_uses_signal")
	$LanternTimer.connect("timeout", self, "_on_lantern_timer_timeout")
	$DarknessDamageTimer.connect("timeout", self, "_on_darkness_damage_timer_timeout")

	$Pike.get_node("RayCast").add_exception(self)
	$PlayerFSM.set_state('running')
	emit_signal('health_modified', self.health)


func drop_lantern():
	$LanternModel.visible = false
	$HeldWeaponSprite.visible = true
	var lantern_instance = lantern_scene.instance()
	get_parent().add_child(lantern_instance)
	lantern_instance.global_transform.origin = self.global_transform.origin + Vector3(0,1,0)
	lantern_in_right_hand = false
	$Lantern.visible = false
	return lantern_instance



func set_player_room(room):
	$DropItemComponent.set_room(room)


func _process(delta):
	$PlayerFSM.current_state.state_process(delta)

	if Input.is_action_just_pressed("r"):
		heal()

func _physics_process(delta):
	$PlayerFSM.current_state.state_physics_process(delta)

func load_ability(ability_str, ability_level):
	$AbilitySlotComponent.load_ability(ability_str,ability_level)
		
func use_ability(slot):
	$AbilitySlotComponent.use_ability(slot)

	
#todo, refactor player damage to use take_hit
func take_hit(damage, _piercing):
	take_damage(damage, _piercing)

func take_damage(damage, _piercing):
	if !invulnerable && $PlayerFSM.current_state_index != 'dead' && !ProjectSettings.get_setting('netherreich/gameplay/god_mode'):
		$PlayerFSM.set_state('staggered')
		invulnerable = true
		self.health -= damage
		Logger.log(self, "ow! health: %s" % self.health)
		emit_signal('damaged')
		emit_signal('health_modified', self.health)
		play_take_damage_sound(self.health)

		if health <= 0:
			$PlayerFSM.set_state('dead')
			emit_signal("dead")
		else:
			$IFrameTimer.start()

func init_ui_signals():
	emit_signal('health_modified', self.health)

func take_parry():
	pass

func sidestep():
	$PlayerFSM.set_state('sidestep')

func move_and_slide_2d(_motion):
	$Plane2DMovementHelper.plane_2d_move_and_slide(_motion)

func melee_attack():
	$LanternTimer.stop()
	$LanternTimer.start()
	if lantern_in_right_hand:
		lantern_instance = drop_lantern()
	$PlayerFSM.set_state('attacking')

func melee_parry():
	
	$Pike.parry()
	$PlayerFSM.set_state('parrying')

func ranged_attack():
	$AnimatedSprite.play('shoot')
	# $Rifle.shoot(self, (self.get_global_mouse_position() - self.position).normalized())

func block():
	if blocking:
		$Pike.block()

func reload(ammo_type):
	$Rifle.load(ammo_type)

func get_direction_to_mouse():
	var mouse_position_on_viewport = get_viewport().get_mouse_position()
	var ray_origin = camera.project_ray_origin(mouse_position_on_viewport)
	var ray_target = ray_origin + camera.project_ray_normal(mouse_position_on_viewport) * 1000

	var intersection = self.get_world().direct_space_state.intersect_ray(ray_origin, ray_target, [], 524288)
	
	if(!intersection.empty()):
		var pos = intersection.position
		return (pos - self.global_transform.origin).normalized()

func setUsingLeftHandItemStateToAnimation(animation):
	state_to_animation['using_left_hand_item'] = animation

func set_animation(animation_index):
	$AnimatedSprite.play(animation_index)

func set_left_hand_item(item):
	$PlayerFSM.set_left_hand_item(item)

func get_left_hand_item():
	return $PlayerFSM.get_left_hand_item()

func drop_left_hand_item():
	if item_uses > 0:
		$DropItemComponent.drop_pickup(held_item)


func drop_ability_pickup(_slot=null, _pickup_name=""):
	if _slot == null:
		$DropItemComponent.drop_pickup(_pickup_name)
	else:
		$DropItemComponent.drop_pickup(_slot.pickup_name)


func has_ability(ability_str):
	return $AbilitySlotComponent.is_ability_already_assigned(ability_str)


func initialise_item_uses_ui_non_firearm_item():
	$PlayerFSM/UsingLeftHandItemState.initialise_item_uses_ui_non_firearm_item()

func heal():
	if health < starting_health:
		health += $HealthRestoration.get_heal_amount()
		if health > starting_health:
			health = starting_health
		emit_signal('health_modified', self.health)

func recharge_healh_resoration(amount):
	$HealthRestoration.recharge_healh_resoration(amount)

func modify_auto_reload_progress(progress_delta):
	$Rifle.modify_auto_reload_progress(progress_delta)

func emit_explosion_signal():
	emit_signal("explosion")

func _on_PlayerFSM_state_transition(state_index):
	set_animation(state_to_animation[state_index])

func _on_LeftHandItemFSM_state_transition(state_index):
	set_animation(state_to_animation['using_left_hand_item'])

func _on_IFrame_timeout():
	invulnerable = false

func _on_item_uses_signal(num_uses):
	item_uses = num_uses

func _on_receive_held_item_signal(item):
	held_item = item

func _on_reload_progress_signal_received(reload_progress):
	emit_signal("reload_progress_modified", reload_progress)


func pickup_lantern():
	stop_darkness_damage()
	$LanternModel.visible = true
	$HeldWeaponSprite.visible = false
	lantern_instance.queue_free()
	lantern_in_right_hand = true
	$Lantern.visible = true
	
func set_has_artefact(value):
	Logger.log(self, "Got the artefact!")
	self.has_artefact = value

func play_footstep_sound(sound_id):
	if sound_id:
		$FootstepsAudioStreamPlayer3D.stream = self.sounds[sound_id]
		$FootstepsAudioStreamPlayer3D.play()

func play_energy_pickup_sound():
	$EnergyAudioStreamPlayer.play()

func stop_footstep_sound():
	$FootstepsAudioStreamPlayer3D.stop()

func play_take_damage_sound(hp):
	if health > 0:
		$TakeDamageAudioStreamPlayer3D.stream = self.sounds["injured"]
	else:
		$TakeDamageAudioStreamPlayer3D.stream = self.sounds["dead"]
	$TakeDamageAudioStreamPlayer3D.play()

func play_pickup_sound():
	$PickupAudioStreamPlayer3D.play()


func start_darkness_damage():
	if !lantern_in_right_hand:
		$DarknessDamageSoundStream.play()
		$DarknessDamageSoundStream/Tween.interpolate_property($DarknessDamageSoundStream, "volume_db", -80, 0, 2, 1, Tween.EASE_IN, 0)
		$DarknessDamageSoundStream/Tween.start()
		$DarknessDamageTimer.start()


func stop_darkness_damage():
	$DarknessDamageTimer.stop()		
	$DarknessDamageSoundStream/Tween.interpolate_property($DarknessDamageSoundStream, "volume_db", $DarknessDamageSoundStream.volume_db, -80, 3, 1, Tween.EASE_IN, 0)
	$DarknessDamageSoundStream/Tween.start()

	
func _on_darkness_damage_timer_timeout():
	self.take_damage(5, 100)
