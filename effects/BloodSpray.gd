extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$SprayStreamPlayer3D.pitch_scale = 1 + randf() - 0.5
	rotate(Vector3(0,1,0), randf() * 360)
	$LifeTimer.connect("timeout", self, "_on_life_timer_timeout")
	$CPUParticles2D.emitting = true
	if rand_range(0,6) > 4:
		$CPUParticles2D.one_shot = false
		$LifeTimer.start()

func _on_life_timer_timeout():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
