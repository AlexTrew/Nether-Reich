extends Area


func _ready():
	var __ = self.connect('body_exited', self, '_on_body_exited')
	var _a = self.connect('body_entered', self, '_on_body_entered')

func _on_body_exited(body):
	if body.is_in_group('player'):
		body.start_darkness_damage()

func _on_body_entered(body):
	if body.is_in_group('player'):
		body.stop_darkness_damage()
