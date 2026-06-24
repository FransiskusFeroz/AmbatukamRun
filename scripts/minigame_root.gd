class_name Minigame
extends Node

signal won(next_level_path: String)
signal lost(hint: String)

var next_level: String = ""

func restart():
	set_deferred("process_mode", PROCESS_MODE_DISABLED)
	_on_restart()
	set_deferred("process_mode", PROCESS_MODE_INHERIT)
	Game.minigame_reset.emit()

func _on_restart(): ## @virtual
	pass

func declare_win(): 	won.emit(next_level)
func declare_loss(hint: String): lost.emit(hint)
	
