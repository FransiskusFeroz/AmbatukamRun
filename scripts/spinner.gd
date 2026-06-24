extends Node2D

@export var duration: float = 20
@export var target: float = 1


signal completed
signal failed


var last_rotation: float = 0
var last_touch_position
var progress: float
var rpm: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:


	# Set timer duration
	$Timer.wait_time = duration

	# Animate the spinning symbol:
	var tweena = get_tree().create_tween()
	tweena.tween_property(%Prompt, "rotation", -2*TAU, 2.0)

	var tweenb = get_tree().create_tween()
	tweenb.tween_property(%Prompt, "modulate:a", 1.0, 1.0)
	tweenb.chain().tween_property(%Prompt, "modulate:a", 0.0, 1.0)

	#
	%Progress.max_value = target

	$Timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	# Find the RPM
	var diff = angle_difference(last_rotation, %Spinner.rotation)
	var rps = (diff/delta)/TAU
	var rpm = (rps*60)

	# Update
	progress += abs(diff*delta)
	%Progress.value = progress
	%SpeedLabel.text = str(floor(rpm))
	last_rotation = %Spinner.rotation




func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if not event.pressed:
			last_touch_position = null
	elif event is InputEventScreenDrag:
		if event.index == 0:
			if last_touch_position == null:
				pass
			else:
				var rotation_a = last_touch_position.angle_to_point(%Middle.position)
				var rotation_b = event.position.angle_to_point(%Middle.position)
				%Spinner.rotate(angle_difference(rotation_a, rotation_b))
			last_touch_position = event.position


func _on_timer_timeout() -> void:
	if progress >= target:
		completed.emit()
	else:
		failed.emit()
	queue_free()
