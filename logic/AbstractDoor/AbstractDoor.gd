extends Area
class_name AbstractDoor


var just_entered
var locked


func _ready():
	var __ = self.connect('body_entered', self, '_on_body_entered')
	var __1 = self.connect('body_exited', self, '_on_body_exited')
	self.add_to_group("doors")
	self.just_entered = false
	self.locked = false
	$DoorAndPortcullis/Plane.visible = false

func _on_body_entered(body):
	if body.is_in_group("player") && !self.locked:
		if !just_entered: # this won't stop a race condition
			self.move_player(body)
			
func _on_body_exited(body):
	if body.is_in_group("player"):
		if just_entered:
			just_entered = false

func move_player(player: Player):
	Logger.error(self, "This is an abstract door, mate (subclasses must implement this)", true)

func lock():
	if !ProjectSettings.get_setting("netherreich/gameplay/disable_door_locking"):
		Logger.log(self, "Locking...")
		if !locked:
			$AudioStreamPlayer3D.play()
			self.locked = true
			$DoorAndPortcullis/Plane.visible = true
		else:
			Logger.log(self, "Already locked.")

func unlock():
	Logger.log(self, "Unlocking...")
	if locked:
		$AudioStreamPlayer3D.play()
		self.locked = false
		$DoorAndPortcullis/Plane.visible = false
	else:
		Logger.log(self, "Already unlocked.")

func set_active(value: bool):
	self.active = value
