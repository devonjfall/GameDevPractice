extends CharacterBody3D

#Player speed in meters/sec
@export var speed = 20
#downward acceleration while falling, in m/s^2
@export var fall_acceleration = 75
#Vertical impulse applied upon jumping in m/s
@export var jump_impulse = 20
#Vertical impulse applied on enemy bounce in m/s
@export var bounce_impulse = 16

var target_velocity = Vector3.ZERO

signal hit

func _physics_process(delta):
	#Create a variable to store input direction
	var direction = Vector3.ZERO
	
	#check for move input and update direction accordingly
	#in 3d the ground is the xz plane
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	
	#normalize diagonal movement so that movement is 1 rather than rad(2)
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.basis = Basis.looking_at(direction)
		$AnimationPlayer.speed_scale = 4
	else:
		$AnimationPlayer.speed_scale = 1
	
	#Ground velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	#Vertical velocity
	if not is_on_floor(): #Check if on the floor and apply gravity if not
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
		
	
	#Jump logic
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse
	
	# Iterate through all collisions that occurred this frame
	for index in range(get_slide_collision_count()):
		# Get the current collision
		var collision = get_slide_collision(index)
		
		# if collision is with the ground, it's id will be null
		if collision.get_collider() == null:
			continue
		
		# if the collision is with a mob
		if collision.get_collider().is_in_group("mob"):
			var mob = collision.get_collider()
			# make sure we're hitting it from above
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				#call the squash signal and apply the bounce impulse
				mob.squash()
				target_velocity.y = bounce_impulse
				#and then cancel the loop so that bounces don't stack unpredictably
				break
				
	# Moving the character
	velocity = target_velocity
	move_and_slide()
	#make the character arc while jumping
	$Pivot.rotation.x = PI / 6 * velocity.y / jump_impulse

func die():
	hit.emit()
	queue_free()

func _on_mob_detector_body_entered(body: Node3D) -> void:
	die()
	
