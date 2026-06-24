extends Area2D
func _on_body_entered(body: Node2D) -> void:
	if body is Entity and body.is_in_group("player"):
		Game.level_won.emit()
