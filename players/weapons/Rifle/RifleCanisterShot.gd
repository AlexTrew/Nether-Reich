extends "res://utils/AbstractShot.gd"


var life_remaining = 0.3
var damage_range = [17,22]


func _ready():
	penetration = 1
	speed = 50
	piercing = 120
	damageable_groups = ["enemies"]
	$LifeTimer.connect("timeout", self, "_on_LifeTimerTimeout")

func init(_shooter, _direction):
	.init(_shooter, _direction)
	$LifeTimer.start(life_remaining)


func apply_damage(body):
	damage = rand_range(damage_range[0], damage_range[1])
	body.take_hit(self.damage, self.piercing)
	if body.health > 0 :
		shooter.get_node("TimeScaleSlowdownComponent").damage_enemy_game_slowdown()
	else: 
		shooter.get_node("TimeScaleSlowdownComponent").kill_enemy_game_slowdown()


func _on_LifeTimerTimeout():
	Logger.log(self, "timed out")
	self.queue_free()
