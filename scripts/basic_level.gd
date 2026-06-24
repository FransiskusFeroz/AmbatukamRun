class_name GameWorld
extends Node2D


@export var player: Entity

func _ready():
	player.died.connect(_on_player_death)


func _on_player_death():
	Game.emit_signal("level_lost")


func reset():
	Game.level_reset.emit()
	player.revive()
