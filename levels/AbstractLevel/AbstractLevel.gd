extends Node
class_name AbstractLevel


var artefact_recovered = false

signal room_entered(room_id)
signal room_exited(room_id)
signal level_door_activated


func add_to_id_to_room_map(id, room):
	pass

func connect_level_signals():
	Logger.error(self, "Subclasses must implement this method.")

func start():
	Logger.error(self, "Subclasses must implement this method.")

func _on_LevelDoor_change_level(level_id):
	Logger.log(self, "Forwarding level door signal.")
	emit_signal("level_door_activated", level_id)

func _ready():
	# This is a template function, and these operations are in order. Do not override it (without a super call first).
	# Instead, implement the following methods as necessary.
	Logger.log(self, "Entered the scene tree.")
	self.set_name("Level")
	self.connect_level_signals()
	self.start()
