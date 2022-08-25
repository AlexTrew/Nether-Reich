class_name Logger


static func log(caller: Object, message: String, level="all"):
	var log_message = '[%s] %s: %s' % [OS.get_unix_time(), _get_caller_name(caller), message]
	if level == "all" || (level == "verbose" && ProjectSettings.get_setting("netherreich/logging/verbose")):
		print(log_message)

static func error(caller: Object, message: String, fatal=false):
	var log_message = '[%s] %s : (Error) %s' % [OS.get_unix_time(), _get_caller_name(caller), message]
	print(log_message)

	if fatal && ProjectSettings.get_setting("netherreich/logging/halt_on_fatal_error"):
		assert(false, log_message)

static func _get_caller_name(caller):
	var node = caller
	var caller_name = ""

	while node:
		caller_name = "%s.%s" % [node.name, caller_name]
		node = node.get_parent()

	return caller_name
