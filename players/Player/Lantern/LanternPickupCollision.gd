extends Area



var player

# Called when the node enters the scene tree for the first time.

func _ready():
	$LanternPickupTimer.connect("timeout", self, "_on_lantern_pickup_timer_timeout")

	var __ = self.connect('body_exited', self, '_on_body_exited')
	var _a = self.connect('body_entered', self, '_on_body_entered')


func _process(delta):
	scale_pickup_progress(get_parent().get_node("PickupProgress").get_node("Completed"), get_parent().get_node("PickupProgress").get_node("Remaining"))


func _on_body_entered(body):
	if body.is_in_group('player') && !body.lantern_in_right_hand:
		player = body
			
		if $LanternPickupTimer.is_stopped():
			get_parent().get_node("PickupProgress").visible = true
			$LanternPickupTimer.start()


func _on_body_exited(body):
	if body.is_in_group('player'):
		get_parent().get_node("PickupProgress").visible = false
		$LanternPickupTimer.stop()


func _on_lantern_pickup_timer_timeout():
	player.pickup_lantern()


func scale_pickup_progress(bar_completed, bar_remaining):
	var bar_progress = $LanternPickupTimer.wait_time - $LanternPickupTimer.time_left
	var bar_total_size = $LanternPickupTimer.wait_time
	bar_completed.scale.x = bar_progress/bar_total_size
	bar_remaining.scale.x = -(1 - bar_progress/bar_total_size)
