extends CanvasLayer


func sync_variable_ui_elements():
	Logger.error(self, "Subclasses should implement this method", true)

func connect_ui_signals():
	Logger.error(self, "Subclasses should implement this method", true)

func start():
	Logger.error(self, "Subclasses should implement this method", true)

func _ready():
	Logger.log(self, "Entered scene tree")
	self.set_name("UI")
	self.connect_ui_signals()
	self.sync_variable_ui_elements()
	self.start()
