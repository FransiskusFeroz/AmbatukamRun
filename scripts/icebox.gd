extends Minigame

func _enter_tree() -> void:
	next_level = "level_basic"

func _on_key_interacted(interactor: Node3D) -> void:
	$Root/World/DoorTile.locked = false
	
func _on_win_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		declare_win()
