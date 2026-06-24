extends Node3D


func _process(delta: float) -> void:
	var current_camera = get_viewport().get_camera_3d()
	$Detail.visible = current_camera.global_position.distance_to(global_position) < 30
