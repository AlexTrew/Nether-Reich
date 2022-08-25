extends Area

var lock_position

signal player_entered_camera_trigger_x_lock(lock_position)
signal player_entered_camera_trigger_z_lock(lock_position)
signal player_entered_camera_trigger_no_lock(lock_position)

var lock_type
# Called when the node enters the scene tree for the first time.

func init(lock_type_init):

	lock_position = self.get_parent().global_transform.origin 

	if(lock_type_init == "x"):
		lock_type = "x"
	elif(lock_type_init == "z"):
		lock_type = "z"
	elif(lock_type_init == "none"):
		lock_type = "unlocked"
	

func _ready():
	var __ = self.connect('body_entered', self, '_on_body_entered')



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _on_body_entered(body):
	if body.is_in_group("player"):
		if(lock_type == "x"):
			emit_signal('player_entered_camera_trigger_x_lock', lock_position)
		if(lock_type == "z"):
			emit_signal('player_entered_camera_trigger_z_lock', lock_position)
		if(lock_type == "unlocked"):
			emit_signal('player_entered_camera_trigger_no_lock', lock_position)
