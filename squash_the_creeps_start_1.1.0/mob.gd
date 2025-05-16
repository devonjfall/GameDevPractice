extends CharacterBody3D

# Minimum speed of the mob in meters per second
@export var min_speed = 10
# Max speed in same
@export var max_speed = 18

# Emits when the player jumps on a mob
signal squashed

func _physics_process(_delta):
	move_and_slide()
	

func initialize(start_position, player_position):
	# position the mob by placing it at start_position
	# and rotate it toward player_position, so it looks at the player
	look_at_from_position(start_position, player_position, Vector3.UP)
	# Rotate this mob randomly within range of -45 and +45 degrees
	# so that it doesn't move *directly* towards the player
	rotate_y(randf_range(-PI/4, PI/4))
	
	var random_speed = randi_range(min_speed, max_speed)
	
	#set distance the mob will travel along the vector
	velocity = Vector3.FORWARD * random_speed
	
	#rotate the velocity vector to match the mob's y rotation to match where it's looking from the call at line 14
	velocity = velocity.rotated(Vector3.UP, rotation.y)
	
	#Change animation speed depending on the mob's spawn speed
	$AnimationPlayer.speed_scale = random_speed/min_speed

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()

func squash():
	squashed.emit()
	queue_free() # Destroy this node
