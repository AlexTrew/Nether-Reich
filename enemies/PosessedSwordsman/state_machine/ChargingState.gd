extends "res://utils/AbstractFSMState.gd"


# maxumum speed in pixels/s 
const SPEED = 23.0

# acceleration in pixels/s^2
const ACCELERATION = 1000

#time between entering attacking distance and delivering damage during a charge
#increasing this number will make this enemy easier to parry
const damage_delay = 0.1

var charge_done = false
var ready_to_attack = false
var once = false
var aggressiveness_mod = 0
var temp_target
var direction

func _ready():
	var _c = $ChargingTimer.connect("timeout", self, "_on_ChargingTimer_timeout")
	var _d = $DamageDelayTimer.connect("timeout", self, "_on_DamageDelayTimer_timeout")


func state_physics_process(_delta):
	
	# work out the speed to add this tick (acceleration)
	# note that delta is not used - this motion vector is passed to move_and_slide which will apply delta
	var motion = direction * ACCELERATION
	fsm_owner.motion = (fsm_owner.motion + motion)

	if self.fsm_owner.motion.length() > SPEED:
		self.fsm_owner.motion = self.fsm_owner.motion.normalized() * SPEED
	
func state_process(_delta):
	pass 

func transit():
	fsm_owner.get_node("AnimatedSpriteLegs").animation = "lunge"
	var new_state

	if hit:
		if hit:
			if fsm_owner.injured:
				new_state = 'RECOILING'
				fsm_owner.injured = false
			else:	
				new_state = 'DEFENDING'		

	#i have a bad feeling about this
	elif !once && !ready_to_attack && get_parent().is_at_attacking_distance():
		once = true
		$DamageDelayTimer.start()

	elif ready_to_attack && get_parent().is_at_attacking_distance():
		new_state = 'ATTACKING'

	# ADVANCING transition function 
	elif charge_done && !get_parent().is_at_flanking_distance():
		new_state = 'ATTACKRECOVER'

	elif charge_done:
		new_state = 'ATTACKRECOVER'

	return new_state


func take_hit(value, piercing):
	if piercing > fsm_owner.defense:
		fsm_owner.take_damage(value, piercing)
		fsm_owner.injured = true
	hit = true



func set_aggressiveness_mod(value):
	aggressiveness_mod = value

func _on_ChargingTimer_timeout():
	charge_done = true

func _on_DamageDelayTimer_timeout():
	ready_to_attack = true

func on_transition_to():
	hit = false
	fsm_owner.play_attack_sound()
	fsm_owner.play_footstep_sound("sprinting")
	temp_target = fsm_owner.target
	fsm_owner.look_at(temp_target.global_transform.origin, Vector3.UP)
	direction = -(fsm_owner.global_transform.origin - temp_target.global_transform.origin)
	once = false
	ready_to_attack = false
	charge_done = false
	$ChargingTimer.start(get_parent().CHARGING_DISTANCE / SPEED)



