extends Camera


var target = null
var first = true

var shaking = false
var shake_amount = 2
var shake_time
var cam_offset = 0.15

onready var noise = OpenSimplexNoise.new()
var max_roll = 0.05
var noise_y = 1
var decay = 0.1

func _ready():
	$CameraShakeTimer.connect("timeout", self, "_on_camera_shake_timer_timeout")
	$CameraShakeDelayTimer.connect("timeout", self, "_on_camera_shake_delay_timer_timeout")
	randomize()
	noise.seed = randi()
	noise.period = 4
	noise.octaves = 2

func _physics_process(_delta):
	if target:
		if shaking:
			noise_y+= 1
			rotation.y = max_roll * shake_amount * noise.get_noise_2d(noise.seed, noise_y)
			global_transform.origin.x = target.global_transform.origin.x + (cam_offset * shake_amount * noise.get_noise_2d(noise.seed, noise_y))
			global_transform.origin.z = target.global_transform.origin.z + (cam_offset * shake_amount * noise.get_noise_2d(noise.seed, noise_y))
			if shake_amount > 0:
				shake_amount -= decay
		else:
			global_transform.origin.x = target.global_transform.origin.x
			global_transform.origin.z = target.global_transform.origin.z


	

func shake_reset():
	rotation.y = 0


func set_shake_options():
	pass


func _on_receive_player_damage_signal():
	$CameraShakeTimer.wait_time = 0.2
	shake_amount = 3
	shaking = true
	$CameraShakeTimer.start()


func _on_player_sidestepping_signal_received():
	$CameraShakeTimer.wait_time = 0.1
	shake_amount = 1.5
	shaking = true
	$CameraShakeTimer.start()	


func _on_receive_player_blocking_signal():
	$CameraShakeTimer.wait_time = 0.5
	shake_amount = 2
	shaking = true
	$CameraShakeTimer.start()

func _on_player_lunging_signal_received():
	$CameraShakeTimer.wait_time = 0.1
	shake_amount = 3
	shaking = true
	$CameraShakeTimer.start()	

func _on_receive_player_firing_signal():
	$CameraShakeTimer.wait_time = 0.6	
	$CameraShakeDelayTimer.wait_time = 0.07
	shake_amount = 5
	$CameraShakeDelayTimer.start()

func _on_receive_explosion_signal():
	$CameraShakeTimer.wait_time = 3
	shake_amount = 6
	shaking = true
	$CameraShakeTimer.start()


func _on_camera_shake_timer_timeout():
	shake_reset()
	shaking = false

func _on_camera_shake_delay_timer_timeout():
	shaking = true
	$CameraShakeTimer.start()
