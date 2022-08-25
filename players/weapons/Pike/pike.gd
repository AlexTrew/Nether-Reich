extends Node

var poke_damage = [10,15]
var piercing = 1

signal blocking


func _ready():
	connect("blocking", get_parent().get_parent().get_parent().get_node("Camera"), "_on_receive_player_blocking_signal")

func _process(delta):
	if len($AttackArea.get_overlapping_bodies()) > 0:
		$Flash.visible = true
	else:
		$Flash.visible = false
		
func attack():
	var closest_body = null
	var closest_dist = 100
	for body in $AttackArea.get_overlapping_bodies():
		$RayCast.set_cast_to(body.transform.origin)
		var dist = (body.global_transform.origin - self.global_transform.origin).abs().length()
		if(dist < closest_dist):
			closest_body = body
			closest_dist = dist
	if(closest_body != null):
		var damage = rand_range(poke_damage[0], poke_damage[1])
		closest_body.take_hit(damage, piercing)
		if closest_body.health > 0:
			get_parent().get_node("TimeScaleSlowdownComponent").damage_enemy_game_slowdown()
		else:
			get_parent().get_node("TimeScaleSlowdownComponent").kill_enemy_game_slowdown()
	
func parry():
	#$AnimationPlayer.play("stab")
	for body in $ParryArea.get_overlapping_bodies():
		body.take_parry()


func block():
	#$AnimationPlayer.play("stab")
	for body in $BlockArea.get_overlapping_bodies():
		body.take_block()
		#need to rethink this
		#emit_signal('blocking')

