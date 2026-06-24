class_name WeaponComponent
extends Node2D

@export_enum("Straight", "Side") var grip_style: int
@export var texture: Texture2D
@export var bullet: PackedScene
@export var cooldown: float = 1.0
var can_shoot: bool:
	get:
		return $CooldownTimer.time_left <= 0.0
	set(new):
		if new:
			$CooldownTimer.stop()
		else:
			$CooldownTimer.start()

func _ready():
	pass
