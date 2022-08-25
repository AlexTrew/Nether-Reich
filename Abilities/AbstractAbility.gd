extends Node

var cooldown_time
var ability_ready
var pickup_name

func _ready():
	$AbilityCooldownTimer.connect("timeout", self, "_on_ability_cooldown_timer_timeout")

func init(level):
	$AbilityCooldownTimer.wait_time = cooldown_time
	
	#level param will determine how powerful the attack is; it will scale over time

func use_ability():
	assert(false, "This method is abstract; implement in a concrete class!")

func _on_ability_cooldown_timer_timeout():
	ability_ready = true
