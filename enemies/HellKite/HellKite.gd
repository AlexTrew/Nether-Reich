extends "res://enemies/AbstractEnemy/AbstractEnemy.gd"

var death_smoke_scene = preload("res://effects/SummonSmokeEffect.tscn")

var sounds = {
	"stab_impact": preload("res://common/assets/sounds/stab.wav")
}

func _init():
	health = 50
	attack_damage = 18
	defense = 80

	state_to_animation = {
		'IDLE': 'idle',
		'ADVANCING': 'idle',
		'FLANKING': 'idle',
		'ATTACKING': 'exhale',
		'DEAD': 'dead'
	}

func _ready():
	set_drop_component($DropItemComponent)
	$StateMachine.set_state('ADVANCING')

func take_damage(value, piercing):
	damage_sprite_modulate()
	$DamageAudioStreamPlayer3D.play()
	health -= value
	.send_modify_health_signal(health)
	Logger.log(self, "took %s damage, my health is %s" % [value, health])
	if health <= 0:
		die()

func take_hit(value, piercing):
	if health > 0:
		$StateMachine.current_state.take_hit(value, piercing)

func attack():
	for body in $AttackArea.get_overlapping_bodies():
		if body.is_in_group("player"):
			body.take_damage(attack_damage, attack_damage)


func spawn_death_smoke():
	var death_smoke_scene_instance = death_smoke_scene.instance()
	get_parent().add_child(death_smoke_scene_instance)
	death_smoke_scene_instance.scale = Vector3(0.14, 0.1, 0.14)
	death_smoke_scene_instance.global_transform.origin = self.global_transform.origin + Vector3(0, 1, 0)



func die():
	.die()
	spawn_death_smoke()
