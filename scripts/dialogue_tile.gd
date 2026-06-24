extends Area2D

@export var dialog: Array[PackedStringArray]

var triggered: bool = false


func _ready():
	Game.level_reset.connect(_on_reset)


func _on_body_entered(body):
	if body is Entity and body.is_in_group("player"):
		Game.dialogue.emit(dialog)
		queue_free()


func _on_reset():
	triggered = false
