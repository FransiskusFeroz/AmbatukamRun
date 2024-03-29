extends UserEntity


var added_velocity: Vector2
func _ready():
	pass


func _process(delta):
	# set [[added_velocity]] to zero
	added_velocity = Vector2.ZERO
	
	# Move based on input
	added_velocity.x += Input.get_axis("move_left", "move_right")
	added_velocity.y += Input.get_axis("move_up", "move_down")
	
	# apply added velocity
	move(added_velocity.limit_length())
	
