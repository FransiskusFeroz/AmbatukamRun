extends Node

var always_unlocked: PackedStringArray = [
	"level_test",
	"level_01",
	"level_03",
	]



@onready var level_select: OptionButton = \
		$Title/Interface/Root/MainDivisor/Lower/Padding/Buttons/Level

func _enter_tree() -> void:
	if not FileAccess.file_exists("user://levels.dat"):
		var file = FileAccess.open("user://levels.dat", FileAccess.WRITE)
		file.store_var(PackedStringArray([]))
		file.close()
	
	var save_data = FileAccess.open("user://levels.dat", FileAccess.READ)
	Game.unlocked_levels = save_data.get_var()

func _ready():
	var available_levels = Game.unlocked_levels.duplicate()
	available_levels.append_array(always_unlocked)
	available_levels.sort()
	for level in available_levels:
		level_select.add_item(level)

func _on_play_pressed():
	var level_name = level_select.text
	$Title.queue_free()
	var main_scene : Node = preload("res://scenes/main.tscn").instantiate()

	main_scene.name = "Level"
	main_scene.load_level("res://scenes/levels/" + level_name + ".tscn")

	add_child.call_deferred(main_scene)

func _on_quit_pressed():
	get_tree().quit()

func _exit_tree() -> void:
	var save_data = FileAccess.open("user://levels.dat", FileAccess.WRITE)
	save_data.store_var(Game.unlocked_levels)
