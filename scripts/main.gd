extends Node

var a = 1

func _ready():
	$UILayer.set_process(false)
	
	Game.level_lost.connect(_on_level_lost)
	Game.level_won.connect(_on_level_won)
	Game.dialogue.connect(_on_dialogue_request)

	Game.load_minigame.connect(load_minigame)

func load_level(level_path: String):

	var level: Node2D = load(level_path).instantiate()

	level.name = "Level"
	if get_node_or_null("Level"):
		$level.queue_free()

	add_child(level)

func _on_level_lost():

	Game.paused = true

	$UILayer.set_process(true)
	$UILayer/GameOver.show()
	$UILayer/GameOver.play()
	$Level.call_deferred("set_process_mode", Node.PROCESS_MODE_DISABLED)
	await $UILayer/GameOver.finished
	$UILayer/GameOver.hide()

	$Level.reset()
	await get_tree().process_frame
	$Level.call_deferred("set_process_mode", Node.PROCESS_MODE_INHERIT)
	Game.paused = false
	$UILayer.set_process(false)

func _on_level_won():

	$UILayer.set_process(true)
	
	# Alert headphone users
	OS.alert("Hati-hati bagi pengguna headset", "PERINGATAN!")

	# Play victory video
	$UILayer/Victory.show()
	$UILayer/Victory.play()
	$Level.queue_free()

	await $UILayer/Victory.finished

	# Close game
	OS.alert("saya malas buat next level, jadi buka lagi ya...\n(makanya bantu)", "Mohon maaf...")
	get_tree().quit()

func _on_dialogue_request(data: Array=[["", "Galat Dialog. Kasih tau devnya"]]):

	$UILayer.set_process(false)

	# Pause the game
	$Level.player.controllable = false
	Game.paused = true
	# Show the dialog box
	$UILayer/Dialogue.show()
	for text in data:
		# set speaker and image
		$UILayer/Dialogue/Main/Speaker/Content.text = text[0]
		$UILayer/Dialogue/Main/Text/Content.text = ""
		if text.size() >= 3:
			var image = load(text[2])
			$UILayer/Dialogue/Main/Image.texture = image
			$UILayer/Dialogue/Main/Image.show()
		else:
			$UILayer/Dialogue/Main/Image.hide()
			
		var to_append: String = ""
		var bracket = false
		for chr in text[1]:
			if chr == "[":
				bracket = true
			if bracket:
				to_append += chr
				if chr == "]":
					var filter = to_append.substr(1, len(to_append) - 2)
					filter = filter.split("=", true, 1)
					print(filter)
					match Array(filter):
						["wait", var time]:
							await get_tree().create_timer(time.to_float()).timeout
						_:
							$UILayer/Dialogue/Main/Text/Content.append_text(to_append)
					to_append = ""
					bracket = false
					continue
			else:
				$UILayer/Dialogue/Main/Text/Content.append_text(chr)
				if chr in ".?!,":
					await get_tree().create_timer(0.1).timeout
				else:
					await get_tree().create_timer(0.05).timeout
				
		
		await $UILayer/Dialogue/Main/Buttons/Continue.button_up

		
	# Hide the dialog box
	$UILayer/Dialogue.hide()
	Game.emit_signal("dialogue_finished")
	# Resume the game
	$Level.player.controllable = true
	Game.paused = false


# Minigames #
## Load a minigame
func load_minigame(path:String, next:String):
	if get_node_or_null("Level"):
		$Level.queue_free()
	var mg_scene: PackedScene = load(path)
	var minigame: Minigame = mg_scene.instantiate()
	minigame.name = "Minigame"
	minigame.next_level = next
	minigame.won.connect(_on_minigame_won)
	minigame.lost.connect(_on_minigame_lost)
	await get_tree().process_frame
	add_child(minigame)

var _fallback_hint = """
Petunjuk tidak diberikan. Mampus lu wkwk
(ini bug, bilang dev nya.)
"""
# ganti gak ya???

func _on_minigame_lost(hint: String = _fallback_hint):
	$UILayer.set_process(true)
	%HintLabel.text = hint
	$UILayer/MinigameLose.show()
	await %MinigameReset.pressed
	$UILayer/MinigameLose.hide()
	get_node("Minigame").restart()
	$UILayer.set_process(false)

func _on_minigame_won(next_level_name: String = "level_test"):
	$UILayer.set_process(true)
	
	if next_level_name not in Game.unlocked_levels:
		Game.unlocked_levels.append(next_level_name)
	%UnlockLabel.text = next_level_name
	$UILayer/MinigameWin.show()
	await %MinigameContinue.pressed
	$UILayer/MinigameWin.hide()
	get_node("Minigame").queue_free()
	load_level("res://scenes/levels/" + next_level_name + ".tscn")
	$UILayer.set_process(false)
