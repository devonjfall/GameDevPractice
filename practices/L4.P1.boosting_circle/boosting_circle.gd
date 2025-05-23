extends Sprite2D

var boost_speed := 1200.0
var normal_speed := 600.0
var current_speed := normal_speed

var velocity := Vector2(0, 0)
var steering_factor := 1.0


func _process(delta: float) -> void:
	var direction := Vector2(0, 0)
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")

	if direction.length() > 1.0:
		direction = direction.normalized()

	if Input.is_action_just_pressed("boost"):
		# Replace the pass keyword with the code to change the max_speed, get the timer node, and start it.
		current_speed = boost_speed
		get_node("Timer").start()
	
	var desired_velocity := current_speed * direction
	var steering_vector := desired_velocity - velocity
	velocity += steering_vector * steering_factor * delta
	
	#velocity = direction * current_speed
	position += velocity * delta
	if direction.length() > 0.0:
		rotation = velocity.angle()


func _on_timer_timeout() -> void:
	current_speed = normal_speed
