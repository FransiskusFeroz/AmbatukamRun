extends Camera3D

var finger_index = null

var pitch_angle: float

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			if finger_index == null:
				if check_touch_area(event.position):
					finger_index = event.index
		else:
			if finger_index == event.index:
				finger_index = null

	if event is InputEventScreenDrag:
		if event.index == finger_index:
			pitch_angle += event.screen_relative.y * Game.camera_sensitivity
			pitch_angle = clampf(pitch_angle, -0.5*PI, 0.5*PI)

			basis = Basis()
			get_parent().rotate_object_local(Vector3.UP, -event.screen_relative.x * Game.camera_sensitivity)
			rotate_object_local(Vector3.RIGHT, pitch_angle)

func check_touch_area(touch_position: Vector2) -> bool:
	return touch_position.x > get_viewport().get_visible_rect().size.x / 2
