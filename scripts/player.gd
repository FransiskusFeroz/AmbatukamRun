extends Entity

@export var controllable: bool = true:
	set(new):
		controllable = new
		_update_input_layer()
	get():
		if _gliding:
			return false
		else:
			return controllable
@export var max_stamina: float = 2

var added_velocity: Vector2
var stamina: float = max_stamina

func _enter_tree() -> void:
	Game.paused_changed.connect(_on_paused_changed)

func _ready():
	super._ready()
	Game.checkpoint_reached.connect(set_spawnpoint)

func _process(delta):
	super._process(delta)

	if controllable and not Game.paused:
		# move character
		added_velocity = %Joystick.get_velocity()

		# apply velocity & recharge stamina
		if not added_velocity:
			stamina = min(stamina + delta/2, max_stamina)
		elif Input.is_action_pressed("action_dash"):

			if stamina > 0.0:
				stamina -= delta
				added_velocity *= 2.0

		move(added_velocity)

		# Shoot weapon if button pressed
		if Input.is_action_pressed("action_shoot"):
			shoot()

func _force_move(by: Vector2, execute: bool = true):
	super._force_move(by, execute)
	if by:
		if not $WalkAudio.playing:
			$WalkAudio.play()
		$WalkAudio.pitch_scale = by.length()
	else:
		$WalkAudio.stop()

# Kill the player
func _kill():
	emit_signal("died")
	controllable = false
	set_process(false)
	$Center.hide()

func revive():
	health = 100
	$Center.show()
	controllable = true
	set_process(true)

func set_spawnpoint(target_position: Vector2):
	init_position = target_position


func _update_input_layer():
	if get_node_or_null("Input"):
		if controllable and (not Game.paused):
			$Input.show()
		else:
			$Input.hide()

func _on_paused_changed(new: bool):
	if new == true:
		$WalkAudio.stop()
	_update_input_layer()
