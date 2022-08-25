extends KinematicBody


var number_of_pellets = 12
var spread = deg2rad(30)
var delay 
var rolling

var speed = 2

var acceleration = 100

var motion

var player

var bullet_scene = preload("res://deployables/CannisterCannonDeployable/CanisterCannonProjectile.tscn")
var smoke_effect_scene = preload("res://effects/MusketSmokeEffect.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	rolling = true
	$FuseTimer.connect("timeout", self, "_on_fuse_timer_timeout")
	$RecoilTimer.connect("timeout", self, "_on_recoil_timer_timer")


func init(_delay, _player):
	delay = _delay
	player = _player
	$FuseTimer.start(delay)


func _process(delta):
	if rolling:
		motion = self.global_transform.basis.z * acceleration

		if motion.length() > speed:
			motion = motion.normalized() * speed

		$Plane2DMovementHelper.plane_2d_move_and_slide(motion)


func take_block():
	pass

func take_hit():
	pass


func fire(direction):
	player.emit_explosion_signal()
	$FireAudioStreamPlayer3D.play()

	var smoke_effect = smoke_effect_scene.instance() 
	self.get_parent().add_child(smoke_effect)
	smoke_effect.global_transform.origin = self.global_transform.origin + Vector3(0,1,0)
	smoke_effect.scale = Vector3(0.15, 0.1, 0.15)

	direction.y = 0
	var initial_pellet_direction = direction.rotated(Vector3.UP, -spread / 2)
	var pellet_delta_direction = spread / number_of_pellets

	for n in range(number_of_pellets):
		var bullet = bullet_scene.instance()
		self.get_parent().add_child(bullet)
		bullet.transform.origin = self.transform.origin
		var pellet_direction = initial_pellet_direction.rotated(Vector3.UP, n * pellet_delta_direction)
		bullet.init(self, pellet_direction)
	speed = 20
	$RecoilTimer.start()
	

func _on_fuse_timer_timeout():
	fire(-(self.global_transform.basis.z))


func _on_recoil_timer_timer():
	rolling = false
