extends Spatial

var life_remaining = 5

func _ready():
	$CPUParticles2D.emitting = true
	$LifeTimer.connect("timeout", self, "_on_LifeTimerTimeout")
	$LifeTimer.start(life_remaining)

func _on_LifeTimerTimeout():
	queue_free()
