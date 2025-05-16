extends Sprite2D

var velocity := Vector2(0,0)
var max_speed := 600.0
var current_speed := max_speed
var boost_speed := 1500.0
var direction := Vector2(0,0)
var steering_factor := 10.0

func _process(delta: float) -> void:
	
	direction.x = Input.get_axis("move_left","move_right")
	direction.y = Input.get_axis("move_up","move_down")
	if direction.length() > 1.0:
		direction = direction.normalized()
	
	
	if Input.is_action_just_pressed("boost"):
		current_speed = boost_speed
		get_node("Timer").start()
	
	var desired_velocity := current_speed * direction
	var steering_vector := desired_velocity - velocity
	
	velocity += steering_vector * steering_factor * delta
	position += velocity * delta
	if direction.length() > 0.0:
		rotation = velocity.angle()


func _on_timer_timeout() -> void:
	current_speed = max_speed
