extends GameWorld


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.controllable = false
	super._ready()
	var tween = get_tree().create_tween()
	tween.tween_property($Overlay/ColorRect, "color:a", 0.0, 2.0)
	tween.tween_callback($Overlay.hide)
	await tween.finished
	Game.dialogue.emit([
		["Budi", "[i]*menguap*[/i] watafakk[wait=0.1].[wait=0.1].[wait=0.1]."],
		["Budi", "hah? [shake rate=100.0 level=5 connected=1]GUA DIMANA?[/shake]"]
		])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

#>--- EVENTS ---<#

func _on_pisang_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Game.dialogue.emit([["Budi", "apaan tuh?"]])
		var cutscene_cam := Camera2D.new()
		cutscene_cam.position = $Player.position
		add_child(cutscene_cam)
		cutscene_cam.make_current()
		await Game.dialogue_finished
		Game.paused = true
		var camera_tween: Tween = get_tree().create_tween()
		camera_tween.tween_property(cutscene_cam, "position", $Pisang.position, 0.5)
		camera_tween.tween_interval(1)
		camera_tween.tween_property(cutscene_cam, "position", $Player.position, 0.5)
		await camera_tween.finished
		$Player/Camera.make_current()
		cutscene_cam.queue_free()
		Game.dialogue.emit([
			["Budi", "pas bener gw belum sarapan"],
			["Budi", "enak tuh😍"]
		])
		Game.paused = true
		await Game.dialogue_finished
		$Player.glide($Pisang.position)
		await $Player.glide_finished
		Game.dialogue.emit([["Budi", "*sambil memakan* masalahnya gw keluar macem mana?"]])
		$Pisang.queue_free()
		$PisangArea.queue_free()
