extends "res://utils/AbstractFSMState.gd"


var held_item
signal held_item_signal(held_item)
signal uses_signal(uses)

var move_animation


func _ready():
	fsm_owner.get_node("LegsSpriteHolder").connect("play_reverse_legs_animation", self, "_on_receive_reverse_legs_animation_signal")
	fsm_owner.get_node("LegsSpriteHolder").connect("play_move_right_legs_animation", self, "_on_receive_move_right_legs_animation_signal")
	fsm_owner.get_node("LegsSpriteHolder").connect("play_move_left_legs_animation", self, "_on_receive_move_left_legs_animation_signal")
	$LeftHandItemFSM.set_state('done')
	set_left_hand_item('nothing')
	
	
func on_transition_to():
	move_animation = "move"
	fsm_owner.get_node("LegsSpriteHolder").get_node("AnimatedSpriteLegs").flip_h = false
	if held_item == 'pistol':
		$LeftHandItemFSM.set_state('draw_pistol')
	elif held_item == 'blunderbus':
		$LeftHandItemFSM.set_state('draw_pistol')
	elif held_item == 'cannister_cannon_deployable':
		$LeftHandItemFSM.set_state('cannister_cannon_deployable')
	else:
		pass
	
func transit():
	if $LeftHandItemFSM.get_current_state_index() == 'done':
		fsm_owner.get_node("LegsSpriteHolder").get_node("AnimatedSpriteLegs").flip_h = true
		return 'running'


func state_process(_delta):

	if fsm_owner.motion.length() > 1 && fsm_owner.get_node("LegsSpriteHolder").get_node("AnimatedSpriteLegs").animation == "idle":
		fsm_owner.get_node("LegsSpriteHolder").get_node("AnimatedSpriteLegs").play(move_animation)
	elif fsm_owner.motion.length() < 1:
		fsm_owner.get_node("LegsSpriteHolder").get_node("AnimatedSpriteLegs").animation = "idle"
	
		
	$LeftHandItemFSM.state_objects[$LeftHandItemFSM.get_current_state_index()].state_process(_delta)


func state_physics_process(_delta):
	$LeftHandItemFSM.state_objects[$LeftHandItemFSM.get_current_state_index()].state_physics_process(_delta)

func set_left_hand_item(item):
	Logger.log(self, 'I am holding ' + item)
	held_item = item
	emit_signal("held_item_signal", held_item)

func get_left_hand_item():
	return held_item

func set_animation(anim):
	fsm_owner.setUsingLeftHandItemStateToAnimation(anim)

func initialise_item_uses_ui_non_firearm_item():
	$LeftHandItemFSM.initialise_item_uses_ui_non_firearm_item()

func _on_receive_uses_count(uses):
	emit_signal("uses_signal", uses)

func _on_receive_move_right_legs_animation_signal():
	move_animation = "move_side_right"
	fsm_owner.get_node("LegsSpriteHolder").get_node("AnimatedSpriteLegs").play(move_animation)

func _on_receive_reverse_legs_animation_signal(reverse):
	if reverse:
		move_animation = "move_backwards"
	else:
		move_animation = "move"
		fsm_owner.get_node("LegsSpriteHolder").get_node("AnimatedSpriteLegs").play(move_animation)

func _on_receive_move_left_legs_animation_signal():
	move_animation = "move_side_left"
	fsm_owner.get_node("LegsSpriteHolder").get_node("AnimatedSpriteLegs").play(move_animation)
