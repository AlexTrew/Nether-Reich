extends Control
class_name Console


var available_commands = {}
var history = []
var history_index = 0


func _ready():
	for command in $Commands.get_children():
		available_commands[command.keyword] = command

func _process(_delta):
	if Input.is_action_just_pressed("rightslash"):
		self.toggle_visibility()

	if visible:
		if Input.is_action_just_pressed("enter"):
			var input_text = $TextEdit.text

			history.append(input_text)
			history_index = 0

			var input = input_text.split(' ')
			var command = input[0]
			var args = Array(input).slice(1, INF)
			var command_object = available_commands.get(command)
			var result = ""
			if command == 'help':
				result = help()
			elif command == 'clear':
				result = clear()
			elif command_object:
				result = command_object.execute(args)
			else:
				result = "No such command."
			self.output(input[0], result)
			self.clear_input()

		elif Input.is_action_just_pressed("ui_up"):
			if (history_index - 1) >= (-1 * len(history)):
				history_index -= 1
				set_input(history[history_index])

		elif Input.is_action_just_pressed("ui_down"):
			if (history_index + 1) < 0:
				history_index += 1
				set_input(history[history_index])

func toggle_visibility():
	visible = !visible
	if visible:
		self.clear_input()
		self.grab_focus()

func set_input(text):
	$TextEdit.text = text

func clear_input():
	$TextEdit.text = ""

func output(command: String, response: String):
	$RichTextLabel.add_text("> " + command)
	$RichTextLabel.newline()
	$RichTextLabel.add_text(response)
	$RichTextLabel.newline()

# Built-in commands
func clear():
	$RichTextLabel.clear()
	return "Cleared output."

func help():
	var help_text = "Available commands: \n"
	for command in available_commands.values():
		help_text += "'%s': %s\n" % [command.keyword, command.description]
	return help_text
