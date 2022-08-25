extends "res://utils/AbstractShot.gd"

var damage_range = [25,30]

func _ready():
	damage = 2
	speed = 90
	piercing = 100
	penetration = 3
	damageable_groups = ["enemies"]



func apply_damage(body):
	damage = rand_range(damage_range[0], damage_range[1])
	body.take_hit(self.damage, self.piercing)
	if body.health > 0 :
		shooter.get_node("TimeScaleSlowdownComponent").damage_enemy_game_slowdown()
	else: 
		shooter.get_node("TimeScaleSlowdownComponent").kill_enemy_game_slowdown()