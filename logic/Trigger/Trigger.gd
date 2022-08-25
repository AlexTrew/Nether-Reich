extends Area


signal player_entered
var retrigger = false
var triggered = false
var id

func _ready():
	$EditorIconSprite3D.visible = false
	var __ = self.connect('body_entered', self, '_on_body_entered')

func _on_body_entered(body):
	if body.is_in_group("player") && (!triggered || retrigger):
		Logger.log(self, 'Player entered trigger')
		emit_signal('player_entered', body)
		triggered = true
