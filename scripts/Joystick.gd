extends Node2D

var current_touch_index = null

func _input(event):
	if event is InputEventScreenTouch:
		# get finger index thats dragging the pad
		if event.pressed:
			if current_touch_index == null:
				if event.position.x <= get_viewport_rect().size.x / 2:
					current_touch_index = event.index
					$Outer.global_position = event.position
		elif event.pressed == false:
			if event.index == current_touch_index:
				$Outer.global_position = global_position
				current_touch_index = null
				$Outer/Inner.position = Vector2.ZERO
	elif event is InputEventScreenDrag:
		if event.index == current_touch_index:
			$Outer/Inner.global_position = event.position
			$Outer/Inner.position = $Outer/Inner.position.limit_length(64)
	elif event is InputEventKey:
		if current_touch_index == null:
			var key_input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
			$Outer/Inner.position = key_input.normalized() * 64
func get_velocity() -> Vector2:
	return $Outer/Inner.position / 64
