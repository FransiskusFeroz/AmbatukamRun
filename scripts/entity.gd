class_name Entity
extends CharacterBody2D
## Base node for things that are "alive"

signal died
signal glide_finished

@export_range(0.0, 100.0, 0.01, "or_greater") var max_health: float = 100.0:
	set(new):
		health = health
		max_health = new

@export_range(0.0, 100.0, 0.01, "or_greater") var health: float = 100.0:
	set(new):
		if new <= 0:
			_kill()

		health = min(new, max_health)


@export_range(0.0, 1024.0, 0.1, "or_greater") var speed: float = 256.0
@export_enum("Ally", "Enemy") var team: int
@export var weapon: WeaponComponent:
	set(new):
		if new == null:
			$Center/Hand.hide()
		else:
			$Center/Hand/Weapon.texture = new.texture
			$Center/Hand.show()
		weapon = new

var aim

var _gliding: bool = false
var _glide_destination: = Vector2.ZERO

@onready var init_position := global_position



func _ready():
	Game.level_reset.connect(_reset)
	#invoke setget functions
	weapon = weapon

func _process(delta):
	if _gliding:
		if not Game.paused:
			var velo = (_glide_destination - position).limit_length((1/speed)*256)
			if _force_move(velo):
				_gliding = false
				glide_finished.emit()
			else:
				var circle = 128 * delta

				if (_glide_destination - position).length() <= circle:
					position = _glide_destination
					_gliding = false
					glide_finished.emit()


func glide(destination: Vector2):
	assert(not _gliding)
	_gliding = true
	_glide_destination = destination


func move(by: Vector2, execute: bool = true):
	## Moves the entity.
	if not _gliding:
		_force_move(by, execute)


func shoot():
	if weapon:
		if weapon.can_shoot:
			var boulet: Node2D = weapon.bullet.instantiate()
			boulet.position = self.position
			boulet.rotation = $Center/Hand.rotation
			if boulet.team:
				boulet.team = self.team
			get_parent().add_child(boulet)
			weapon.can_shoot = false


func _kill():
	emit_signal("died")
	queue_free()


func _force_move(by: Vector2, execute: bool = true):
	$Center/Hand.rotation = by.angle()
	velocity = by * speed
	if execute:
		return move_and_slide()

func _reset():
	global_position = init_position
