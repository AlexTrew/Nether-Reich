extends "res://pickups/AbstractPickup/AbstractPickup.gd"

signal artefact_recovered


func _ready():
	pass

func _process(_delta):
	for body in get_overlapping_bodies():
		if body.is_in_group('player'):
			body.set_has_artefact(true)
			emit_signal('artefact_recovered')
			queue_free()