extends "res://utils/AbstractFSM.gd"


# range within which the rifleman will attempt to attack
var ATTACK_DISTANCE = 8

# range within which the rifleman will walk away from the player
var RETREAT_DISTANCE = 2


func _ready():
	state_objects = {
		'IDLE': $IdleState,
		'ADVANCING': $AdvancingState,
		'AIMING': $AimingState,
		'SHOOTING': $ShootingState,
		'POST_SHOOTING': $PostShootingState,
		'RECOILING': $RecoilingState,
		'STUNNED': $StunnedState,
		'DEAD': $DeadState
	}

	set_state("ADVANCING")

func has_line_of_sight_to_target():
	var raycast = get_parent().get_node("RayCast")
	var target = get_parent().target

	var raycast_vector = get_parent().target.transform.origin - get_parent().transform.origin
	raycast_vector.y = 0
	
	if raycast_vector.length() <= ATTACK_DISTANCE:
		raycast.set_cast_to(raycast_vector)
		#debug_draw_ray_target(get_parent().target.global_transform.origin)

		return raycast.get_collider() == target
	else:
		return false	

func is_dead():
	return get_parent().dead

func debug_draw_ray_target(point):
	var indicator = MeshInstance.new()
	indicator.mesh = preload("res://utils/NavmeshVisualisationPoint/NavmeshVisPoint.tres")
	indicator.global_transform.origin = point
	self.get_parent().get_parent().add_child(indicator)
	Logger.log(self, "debug point spawned at %s" % str(point))

func debug_ray_is_hitting_player(ray, target):
	var object_colliding_with_ray = ray.get_collider()
	if object_colliding_with_ray == target:
		Logger.log(self, "ray is hitting target")
	else:
		Logger.log(self, "Ray is not hitting target: " + str(object_colliding_with_ray))
