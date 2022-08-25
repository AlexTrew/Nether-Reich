extends "res://utils/AbstractShot.gd"


var life_remaining = 0.4


func _ready():
	damage = 20
	penetration = 2
	speed = 30
	piercing = 120
	damageable_groups = ["enemies", "player"]
	$LifeTimer.connect("timeout", self, "_on_LifeTimerTimeout")

func init(_shooter, _direction):
	.init(_shooter, _direction)
	$LifeTimer.start(life_remaining)


func apply_damage(body):
	body.take_hit(self.damage, self.piercing)



func _on_LifeTimerTimeout():
	Logger.log(self, "timed out")
	self.queue_free()
