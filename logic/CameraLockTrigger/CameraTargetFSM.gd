extends "res://utils/AbstractFSM.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	state_objects = {
		'none': $CameraLockUnlockedState,
		'locked_x': $CameraLockXState,
		'locked_z': $CameraLockZState,
	}
	
func set_state(state_index):
	.set_state(state_index)
	Logger.log(self, "camera state set to : " + str(state_index))