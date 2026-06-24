extends Node2D

var x_difference: float
func _ready() -> void:
	x_difference = ProjectSettings.get_setting("display/window/size/viewport_width") - position.x



func _process(delta: float) -> void:
	position.x = get_viewport_rect().size.x - x_difference
