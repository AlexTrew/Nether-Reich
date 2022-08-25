extends 'res://ui/AbstractUI/AbstractUI.gd'


func sync_variable_ui_elements():
	pass

func connect_ui_signals():
	var _restart_level_button_conn = $CenterContainer/VBoxContainer/RestartLevelButton.connect('pressed', Game, '_on_UI_change_level_command', [Game.get_level_id()])
	var _exit_to_menu_button_conn = $CenterContainer/VBoxContainer/ExitToMenuButton.connect('pressed', Game, '_on_UI_exit_to_menu_command')
	var _exit_game_button_conn = $CenterContainer/VBoxContainer/ExitGameButton.connect('pressed', Game, '_on_UI_exit_game_command')

func start():
	pass
