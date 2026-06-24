extends Entity

@export var target: Node2D

@onready var navi_agent: NavigationAgent2D = $Navi

func _enter_tree() -> void:
	Game.paused_changed.connect(_on_paused_changed)

func _ready():
	super._ready()
	navi_setup()

func navi_setup():
	await get_tree().physics_frame
	pathfind()

func _process(delta):
	super._process(delta)
	$Sight.target_position = to_local(target.position)

func _physics_process(_delta):
	if not Game.paused:
		if $Sight.get_collider() == target:
			var velo: Vector2 = to_local(navi_agent.get_next_path_position()).normalized().rotated(rotation)
			move(velo)
			$Audio.stream_paused = false
		else:
			$Audio.stream_paused = true
	else:
		$Audio.stream_paused = true

func pathfind():
	navi_agent.target_position = target.global_position


func _on_navi_timer_timeout():
	pathfind()

func move(by: Vector2, execute: bool = true):
	## Moves the entity.
	velocity = by * speed
	if execute:
		move_and_slide()

func _on_kill_area_body_entered(body):
	if body is Entity:
		if body.team == 0:
			body.health = 0
			
func _on_paused_changed(value):
	if value:
		$NaviTimer.start()
	else:
		$NaviTimer.stop()
