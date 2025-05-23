extends Sprite2D

var max_speed := 600.0
var boost_speed := 1500.0
var current_speed := max_speed
var velocity := Vector2(0, 0)
# For this practice, we moved the direction vector outside the _process() function.
# This allows the interactive practice to read its value and test if your code passes!
# You can access and change the direction variable inside the _process() function as you did in the lesson.
var direction := Vector2(0, 0)

func _process(delta: float) -> void:
	# The direction is always equal to Vector2(0, 0)! Add code to remedy that.
	
	direction.x = Input.get_axis("move_left","move_right")
	direction.y = Input.get_axis("move_up","move_down")
	if direction.length() > 1.0:
		direction = direction.normalized()
	
	if Input.is_action_just_pressed("boost"):
		max_speed = boost_speed
	
	velocity = direction * max_speed
	position += velocity * delta
	if velocity.length() > 0.0:
		rotation = velocity.angle()
