extends Node3D

@export var locked := false
var open := false

var tween: Tween = null

func _on_interactable_interacted(interactor: Node3D) -> void:
	if not locked:
		if tween == null:
			tween = get_tree().create_tween()
			tween.set_ease(tween.EASE_OUT)
			tween.set_trans(tween.TRANS_QUAD)
			
			if not open:
				open = true
				tween.tween_property($Door, "rotation:y", 0.25*PI, 5.0)
			else:
				open = false
				tween.tween_property($Door, "rotation:y", 0, 5.0)
			await tween.finished
			tween = null
	
