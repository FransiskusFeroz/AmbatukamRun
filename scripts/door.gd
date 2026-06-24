extends StaticBody2D

var closed = false

func _on_sensor_body_entered(body: Node2D) -> void:
	if body is Entity and body.is_in_group("player"):
		set_collision_layer_value(1, true)
		Game.checkpoint_reached.emit(Vector2(position))
		$Sprite.show()
		$Sensor.queue_free()
		$Audio.play()
		await $Audio.finished
		$Audio.queue_free()
