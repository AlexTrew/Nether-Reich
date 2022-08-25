extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

#target of the camera; generally the player
var target

var x_lock
var z_lock
var y_lock


# Called when the node enters the scene tree for the first time.

func _ready():
	$CameraTargetFSM.set_state('none')

func _process(delta):
	if target:
		$CameraTargetFSM.current_state.state_process(delta)

func set_lock_type(lt, pos):
	if(lt == "locked_z"):
		z_lock = pos.z
	if(lt == "locked_x"):
		x_lock = pos.x
	$CameraTargetFSM.set_state(lt)

		
#do all this again with state/strategy pattern
#x lock, z lock, no lock, and transition
