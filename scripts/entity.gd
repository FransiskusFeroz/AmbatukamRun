class_name UserEntity
extends CharacterBody2D
## Base node for things that are "alive"


@export_range(0.0, 100.0, 0.01, "or_greater") var health: float = 100.0
@export_range(0.0, 1024.0, 0.1, "or_greater") var speed: float = 256.0


func _ready():
	pass

func _process(delta):
	pass

func move(by: Vector2, execute: bool = true):
	## Moves the entity.
	velocity = by * speed
	if execute:
		move_and_slide()
