extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer1.connect("finished", self, "_on_audio_stream_1_finish")
	$AudioStreamPlayer2.connect("finished", self, "_on_audio_stream_2_finish")
	$AudioStreamPlayer3.connect("finished", self, "_on_audio_stream_3_finish")
	$AudioStreamPlayer4.connect("finished", self, "_on_audio_stream_4_finish")
	$AudioStreamPlayer5.connect("finished", self, "_on_audio_stream_5_finish")
	$AudioStreamPlayer6.connect("finished", self, "_on_audio_stream_6_finish")


var advance = false

func choose_next_section():
	#todo
	pass


func _on_audio_stream_1_finish():
	if advance:
		$AudioStreamPlayer1.stop()
		$AudioStreamPlayer2.play()
		advance = false
	else:
		$AudioStreamPlayer1.play()

func _on_audio_stream_2_finish():
	if advance:
		$AudioStreamPlayer2.stop()
		$AudioStreamPlayer3.play()
		advance = false
	else:
		$AudioStreamPlayer2.play()

func _on_audio_stream_3_finish():
	if advance:
		$AudioStreamPlayer3.stop()
		$AudioStreamPlayer4.play()
		advance = false
	else:
		$AudioStreamPlayer3.play()

func _on_audio_stream_4_finish():
	if advance:
		$AudioStreamPlayer4.stop()
		$AudioStreamPlayer5.play()
		advance = false
	else:
		$AudioStreamPlayer4.play()

func _on_audio_stream_5_finish():
		$AudioStreamPlayer6.play()

func _on_audio_stream_6_finish():
		$AudioStreamPlayer6.play()