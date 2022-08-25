extends Spatial

var splat_scene = preload("res://enemies/HeadyHandBaller/SplatPart.tscn")

var sounds = {
	"splat1" : preload("res://enemies/HeadyHandBaller/Sounds/splat.ogg"),
	"splat2" : preload("res://enemies/HeadyHandBaller/Sounds/splat2.ogg")
}

const splat_parts = 5
var spawned_splat_parts = 0
var spread = 1



# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():

	$SplatSeparationTimer.connect("timeout", self, "_on_splat_separation_timeout")
	$SplatLifeTimer.connect("timeout", self, "_on_splat_life_timeout")
	play_splat_sound()
	randomize()
	$SplatSeparationTimer.start()
	$SplatLifeTimer.start()


func play_splat_sound():
	if randi()%2 == 0:
		$SplatAudioStreamPlayer3D.stream = sounds["splat1"]
	else:
		$SplatAudioStreamPlayer3D.stream = sounds["splat2"]
	$SplatAudioStreamPlayer3D.play()		

func _on_splat_separation_timeout():
	var splat = splat_scene.instance()
	self.add_child(splat)
	splat.global_transform.origin = self.global_transform.origin + Vector3(rand_range(-spread, spread), 0, rand_range(-spread, spread))
	spawned_splat_parts += 1

	if spawned_splat_parts <= splat_parts:
		$SplatSeparationTimer.start()


func _on_splat_life_timeout():
	queue_free()
