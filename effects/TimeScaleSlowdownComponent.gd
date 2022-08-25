extends Node


const timescale_factor = 0.00001
const kill_slowdown_time = 0.15
const damage_slowdown_time = 0.1


func _ready():
	var __ = $SlowdownTimer.connect("timeout", self, "_on_SlowdownTimer_timeout")
	Engine.time_scale = 1


func damage_enemy_game_slowdown():
	if Engine.time_scale == 1:
		$SlowdownTimer.wait_time = time_mod(timescale_factor, damage_slowdown_time)
		$SlowdownTimer.start()
		Engine.time_scale = timescale_factor


func kill_enemy_game_slowdown():
	if Engine.time_scale == 1:
		$SlowdownTimer.wait_time = time_mod(timescale_factor, kill_slowdown_time)
		$SlowdownTimer.start()
		Engine.time_scale = timescale_factor


func time_mod(timescale_factor, slowdown_time):
	return slowdown_time * timescale_factor 


func _on_SlowdownTimer_timeout():
	Engine.time_scale = 1