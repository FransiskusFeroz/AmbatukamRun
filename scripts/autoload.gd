extends Node

@warning_ignore("unused_signal")
signal dialogue(data: Array) # signal to start a LEVEL dialogue
@warning_ignore("unused_signal")
signal dialogue_finished

signal level_won  # self-explanatory
signal level_lost #

# Levels are like world maps

signal checkpoint_reached(position: Vector2)

signal level_reset # emit on loss

signal load_minigame(path: String, next_level: String, args: Array)
signal minigame_reset

signal paused_changed(value)
var paused = false:
	set(new): 
		paused = new
		paused_changed.emit(new)

var camera_sensitivity: float = 0.002

var unlocked_levels: PackedStringArray
