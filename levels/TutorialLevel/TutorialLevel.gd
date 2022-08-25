extends 'res://levels/AbstractLevel/AbstractLevel.gd'


var camera_target
var camera 

var paused = false
var can_skip_text = false

var stage = 0

var tutorial_dict = {
	"intro" : "I'm going to teach you how to send the enemies of our order back to Hell.",
	"move" : "Use W,A,S,D keys to move.",
	"dodge" : "Press SPACE while moving in a direction to quickly dash in that direction. This is much more effective than just moving to avoid enemy attacks.",
	"block" : "Hold SHIFT to raise your sword and block melee attacks.",
	"attack" : "LEFT CLICK to step through and attack with your melee weapon. I will try to parry you, so try to get around my sword by blocking, moving and dashing. Pick your moment carefully.",
	"pickup" : "Well done. Now pickup this gun with RIGHT CLICK, don't worry, it's not a *real* gun.",
	"shoot" : "Aim by holding CTRL, and shoot by releasing it.",
	"shoot1" : "Now shoot.",
	"reload": "You'll need to collect gunpowder to reload the gun. Many enemies will drop it, but beware. It will go bad very quickly if left on the ground for long",
	"heal": "You can heal yourself by pressing R to drink from your flask. The flask is refilled by collecting the tortured souls of the sinners and abominations you slay",
	"done" : "You are ready. Leave through the door behind me."
}

signal display_character_signal
signal display_text_signal(text)
signal undisplay_character_signal
signal undisplay_text_signal


func connect_level_signals(game):
	var _player_dead_conn = $TutorialRoom/Player.connect("dead", Game, "_on_Player_dead")
	var _level_door_conn = self.connect("level_door_activated", Game, "_on_Level_LevelDoor_activated")

func start():
	Game.set_ui('level')

	$TutorialRoom.connect_tile_signals(self)
	$TutorialRoom/Statics/LevelDoor.lock()

	$TutorialTimer.connect("timeout", self, "_on_tutorial_timer_timeout")
	$MinTimeTextOnScreenTimer.connect("timeout", self, "_on_text_timer_timeout")

	$TutorialRoom.bake_navmesh_from_template()
	$TutorialRoom/PosessedSwordsman.get_node("StateMachine").set_state("IDLE")

	$TutorialTimer.start()
	
	$TutorialRoom/PosessedSwordsman.get_node("StateMachine").set_state("IDLE")
	$TutorialRoom/BlunderbusPickup.monitoring = false
	$TutorialRoom/BlunderbusPickup.visible = false

	$TutorialRoom/BlunderbusPickup2.monitoring = false
	$TutorialRoom/BlunderbusPickup2.visible = false

	camera = $Camera
	camera_target = $TutorialRoom/CameraTarget

	camera.target = camera_target
	camera_target.target = $TutorialRoom/Player

func _process(delta):
	if paused && can_skip_text:
		if Input.is_action_just_pressed('left_click'):
			$TutorialTimer.wait_time = 0.01
			$TutorialTimer.start()

func pause_tutorial(text):
	paused = true
	can_skip_text = false
	$MinTimeTextOnScreenTimer.start()
	$TutorialRoom/Player.can_control = false	
	emit_signal("display_character_signal")
	emit_signal("display_text_signal", text)

func unpause_tutorial():
	paused = false
	$TutorialRoom/Player.can_control = true
	emit_signal("undisplay_character_signal")
	emit_signal("undisplay_text_signal")

func _on_tutorial_timer_timeout():
	if stage == 0:
		pause_tutorial(tutorial_dict["intro"])
		$TutorialTimer.wait_time = 5
		$TutorialTimer.start()
		stage+=1
	elif stage == 1:
		pause_tutorial(tutorial_dict["move"])
		stage +=1
		$TutorialTimer.wait_time = 5
		$TutorialTimer.start()
	elif stage ==2:
		unpause_tutorial()
		stage+=1
		$TutorialTimer.wait_time = 5
		$TutorialTimer.start()
	elif stage ==3:
		pause_tutorial(tutorial_dict["dodge"])
		
		$TutorialTimer.wait_time = 10
		$TutorialTimer.start()
		stage+=1
	elif stage ==4:
		unpause_tutorial()
		$TutorialRoom/PosessedSwordsman.get_node("StateMachine").set_state("ADVANCING")
		$TutorialTimer.wait_time = 10
		$TutorialTimer.start()
		stage+=1	
	elif stage ==5:
		pause_tutorial(tutorial_dict["block"])
		$TutorialRoom/PosessedSwordsman.get_node("StateMachine").set_state("IDLE")
		$TutorialTimer.wait_time = 10
		$TutorialTimer.start()
		stage+=1
	elif stage ==6:
		unpause_tutorial()
		$TutorialRoom/PosessedSwordsman.get_node("StateMachine").set_state("ADVANCING")
		$TutorialTimer.wait_time = 10
		$TutorialTimer.start()
		stage+=1	
	elif stage ==7:
		pause_tutorial(tutorial_dict["attack"])
		$TutorialRoom/PosessedSwordsman.get_node("StateMachine").set_state("IDLE")
		$TutorialTimer.wait_time = 10
		$TutorialTimer.start()
		stage+=1
	elif stage ==8:
		unpause_tutorial()
		$TutorialRoom/PosessedSwordsman.get_node("StateMachine").set_state("ADVANCING")
		$TutorialTimer.wait_time = 15
		$TutorialTimer.start()
		stage+=1
	elif stage ==9:
		pause_tutorial(tutorial_dict["pickup"])
		$TutorialRoom/PosessedSwordsman.get_node("StateMachine").set_state("IDLE")
		$TutorialRoom/BlunderbusPickup.monitoring = true
		$TutorialRoom/BlunderbusPickup.visible = true
		$TutorialRoom/BlunderbusPickup2.monitoring = true
		$TutorialRoom/BlunderbusPickup2.visible = true
		$TutorialTimer.wait_time = 10
		$TutorialTimer.start()
		stage+=1
	elif stage ==10:
		unpause_tutorial()
		$TutorialRoom/PosessedSwordsman.get_node("StateMachine").set_state("IDLE")
		$TutorialTimer.wait_time = 10
		$TutorialTimer.start()
		stage+=1
	elif stage ==11:
		pause_tutorial(tutorial_dict["shoot"])
		$TutorialRoom/PosessedSwordsman.get_node("StateMachine").set_state("IDLE")
		$TutorialTimer.wait_time = 10
		$TutorialTimer.start()
		stage+=1
	elif stage ==12:
		pause_tutorial(tutorial_dict["shoot1"])
		$TutorialRoom/PosessedSwordsman.get_node("StateMachine").set_state("IDLE")
		$TutorialTimer.wait_time = 5
		$TutorialTimer.start()
		stage+=1
	elif stage ==13:
		unpause_tutorial()
		$TutorialRoom/PosessedSwordsman.get_node("StateMachine").set_state("IDLE")
		$TutorialTimer.wait_time = 10
		$TutorialTimer.start()
		stage+=1
	elif stage ==14:
		pause_tutorial(tutorial_dict["reload"])
		$TutorialRoom/PosessedSwordsman.get_node("StateMachine").set_state("IDLE")
		$TutorialTimer.wait_time = 10
		$TutorialTimer.start()
		stage+=1
	elif stage ==15:
		unpause_tutorial()
		$TutorialRoom/PosessedSwordsman.get_node("StateMachine").set_state("IDLE")
		$TutorialTimer.wait_time = 5
		$TutorialRoom/PosessedSwordsman.drop_item_component.drop_pickup("powder", 8)
		$TutorialTimer.start()
		stage+=1
	elif stage ==16:
		$TutorialTimer.wait_time = 5
		$TutorialRoom/PosessedSwordsman.drop_item_component.drop_pickup("powder", 8)
		$TutorialTimer.start()
		stage+=1
	elif stage ==17:
		pause_tutorial(tutorial_dict["heal"])
		$TutorialRoom/PosessedSwordsman.get_node("StateMachine").set_state("IDLE")
		$TutorialTimer.wait_time = 10
		$TutorialTimer.start()
		stage+=1
	elif stage ==18:
		pause_tutorial(tutorial_dict["done"])
		$TutorialRoom/PosessedSwordsman.get_node("StateMachine").set_state("IDLE")
		$TutorialTimer.wait_time = 10
		$TutorialTimer.start()
		stage+=1
	elif stage ==19:
		unpause_tutorial()
		$TutorialRoom/Statics/LevelDoor.unlock()

func _on_text_timer_timeout():
	can_skip_text = true
