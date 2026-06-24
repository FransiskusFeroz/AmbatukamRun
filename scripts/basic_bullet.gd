extends Area2D
## Template for bullets


@export var speed: float
@export var lifetime: float = 1.0
@export var penetration: int
var team: int 

func _ready():
	set_collision_mask_value(team + 2, true)
	$Timer.wait_time = lifetime
	$Timer.start()

func _process(delta):
	position += Vector2.RIGHT.rotated(rotation) * speed * delta
	
	if $Timer.time_left <= 0:
		queue_free()

func _on_body_entered(body):
	if body is Entity:
		if body.team != team:
			body.health -= 10
			queue_free()
	else:
		queue_free()
