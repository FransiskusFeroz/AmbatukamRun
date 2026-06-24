extends Minigame

@export var lives: int = 5
@export var goal: int = 5

var failures: int = 0
var succeses: int = 0

@export var spinner_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func add_spinner():
	var spinner = spinner_scene.instantiate()
	spinner.completed.connect(_on_spinner_completed)
	spinner.failed.connect(_on_spinner_failed)

	var diff_func = func(x): return x

	spinner.target = 1 + diff_func.call(succeses)
	spinner.duration = 10 + diff_func.call(succeses)

	add_child(spinner)



func _on_spinner_completed():
	succeses += 1
	_spinner_transition()


func _on_spinner_failed():
	failures += 1
	_spinner_transition()


func _spinner_transition():
	if failures > lives:
		lost.emit()
	elif succeses >= goal:
		won.emit()
	else:
		$Timer.start()


func _on_restart():
	failures = 0
	succeses = 0
	$Timer.start()


func _on_timer_timeout() -> void:
	add_spinner()
