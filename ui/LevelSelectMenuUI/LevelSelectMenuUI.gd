extends 'res://ui/AbstractUI/AbstractUI.gd'

func sync_variable_ui_elements():
	pass 
	

func connect_ui_signals():
	var _tile_test_conn = $InvadeTileTestButton.connect('pressed', Game, '_on_UI_change_level_command', ['tile_test'])
	var _level_gen_test_conn = $InvadeLevelGenTestButton.connect('pressed', Game, '_on_UI_change_level_command', ['level_gen_test'])
	var _tutorial_test_conn = $InvadeTutorialButton.connect('pressed', Game, '_on_UI_change_level_command', ['tutorial'])

func start():
	pass


