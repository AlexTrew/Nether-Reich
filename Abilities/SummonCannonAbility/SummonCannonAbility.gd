extends "res://Abilities/AbstractAbility.gd"

var placed 

var shots = 1

var fuse_time = 3

var player

var cannon_scene = preload("res://deployables/CannisterCannonDeployable/CannisterShotCannonDeployable.tscn")
var smoke_scene = preload("res://effects/SummonSmokeEffect.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	
	cooldown_time = 60
	player = self.get_parent().get_parent()
	ability_ready = true

func use_ability():
	if ability_ready:
		place_cannon()
		ability_ready = false
		$AbilityCooldownTimer.start()

func place_cannon():
		var cannon_instance = cannon_scene.instance()
		player.get_parent().add_child(cannon_instance)
		cannon_instance.transform = player.transform
		cannon_instance.init(fuse_time, player)

		var smoke_instance = smoke_scene.instance()
		player.get_parent().add_child(smoke_instance)
		smoke_instance.scale = Vector3(0.07, 0.1, 0.07)
		smoke_instance.transform = player.transform


