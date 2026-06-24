extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var nearby_interactables: Array[Interactable]

func _process(delta: float) -> void:
	if not nearby_interactables.is_empty():
		var filter = func(o):
			return $FPSCamera.is_position_in_frustum(o.global_position) and o.enabled
		
		var visible_interactables: Array = nearby_interactables.filter(filter)
		if visible_interactables:
			$HUD/InteractMarker.show()
			var nearest: Interactable = visible_interactables.reduce(get_closest)
			
			$HUD/InteractMarker.position = $FPSCamera.unproject_position(nearest.global_position)
			
			if Input.is_action_just_pressed("action_interact"):
				nearest.interact(self)
		else:
			$HUD/InteractMarker.hide()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	var input_dir : Vector2 = %Joystick.get_velocity()
	if is_on_floor():
		if Input.is_action_just_pressed("action_jump"):
			velocity.y = JUMP_VELOCITY
	
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y))
	if direction:
		if is_on_floor():
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x += direction.x * (SPEED/50)
			velocity.z += direction.z * (SPEED/50)
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
			

	if move_and_slide():
		var collisions = get_last_slide_collision()
		for i in range(collisions.get_collision_count()):
			if collisions.get_angle(i) < PI/4:
				var surface = collisions.get_collider(i)
				var material = 0
				if surface is Solid:
					material = surface.material
				$WalkAudio.walk(material, velocity.length()/SPEED)


func _on_interact_area_area_entered(area: Area3D) -> void:
	if area is Interactable:
		nearby_interactables.append(area)
		$HUD/InteractMarker.show()


func _on_interact_area_area_exited(area: Area3D) -> void:
	nearby_interactables.erase(area)
	if nearby_interactables.is_empty():
		$HUD/InteractMarker.hide()

func get_closest(a:Node3D, b:Node3D) -> Node3D:
	var al = a.global_position.distance_to(global_position)
	var bl = b.global_position.distance_to(global_position)
	return a if al < bl else b
