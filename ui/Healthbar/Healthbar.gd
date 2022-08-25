extends Spatial

var target
var max_health

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func initialise(_target, health):
	target = _target
	max_health = health


func update_healthbar(health):
	print("health is now " + str(health))
	var health_bar_scale = float(health) / float(max_health)
	print("scale " + str(health_bar_scale))
	$BarHolder.scale.x =  health_bar_scale
	$BgHolder.scale.x = -(1 - health_bar_scale)

func _process(delta):
	global_transform.origin = target.global_transform.origin

func _on_health_modified(new_health):
	update_healthbar(new_health)

func _on_dead():
	queue_free()
