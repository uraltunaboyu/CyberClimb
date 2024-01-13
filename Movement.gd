extends CharacterBody3D

# physics
var moveSpeed : float = 5.0
var jumpForce : float = 5.0

#slow descent for glide
var glideGravity: float = 1.0
var glideSpeedMult: float = 1.5

var gravity : float = 12.0
var jumpCount: int = 0
var glide = false

# dash
var dash: bool = false
var dashSpeed: float = 20.0
var dashCooldown: float = 2.0
var dashTimer: float = 0.0
var dashDuration: float = 2.0

#wallrun
var wallNormal

# vectors
var vel : Vector3 = Vector3()
var mouseDelta : Vector2 = Vector2()
var fall: Vector3 = Vector3()


# called 60 times a second
func _physics_process(delta):
	# exit if esc pressed
	if Input.is_action_pressed("exit"):
		get_tree().quit()
	
	# reset the x and z velocity
	vel.x = 0
	vel.z = 0
	
	var input = Vector2()
	
	# movement inputs
	if Input.is_action_pressed("move_forward"):
		input.y -= 1
	if Input.is_action_pressed("move_backward"):
		input.y += 1
	if Input.is_action_pressed("move_left"):
		input.x -= 1
	if Input.is_action_pressed("move_right"):
		input.x += 1
		
	input = input.normalized()
	
	# get the forward and right directions
	var forward = global_transform.basis.z
	var right = global_transform.basis.x
	
	var relativeDir = (forward * input.y + right * input.x)
	
	# set the velocity for regular and dash movements
	if !dash:
		vel.x = relativeDir.x * moveSpeed
		vel.z = relativeDir.z * moveSpeed
	else:
		vel.x = relativeDir.x * dashSpeed
		vel.z = relativeDir.z * dashSpeed
	
	# apply gravity. handles wether it is glideGravity or regular
	if !glide:
		vel.y -= gravity * delta
	else:
		vel.y -= glideGravity * delta
		
	if glide:
		vel.x = vel.x * glideSpeedMult
		vel.z = vel.z * glideSpeedMult
		
	
	# move the player
	set_velocity(vel)
	move_and_slide()
	vel = velocity
	
	# jumping
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() or jumpCount < 1:
			vel.y = jumpForce
			jumpCount += 1
			
	#handles glide.
	if Input.is_action_pressed("jump") and !is_on_floor() and vel.y < 0:
		glide = true
	
	# Reset jumpCount and glide when on the ground
	if is_on_floor():
		jumpCount = 0  
		glide = false
	
	#kinda wall run currently buggyssssss
	if !is_on_floor():
		if Input.is_action_pressed("move_forward"):
			if is_on_wall():
				wallNormal = get_slide_collision(0)
				vel.x = -wallNormal.get_normal().x * moveSpeed
				vel.z = -wallNormal.get_normal().z * moveSpeed
				vel.y = 0  # Disable gravity while on the wall
	

					
# called every frame	

func _process(delta):
	#check for dash
	if Input.is_action_just_pressed("dash") and !dash and dashTimer <= 0:
		dash = true
		dashTimer = dashCooldown
	
	#handles dash
	if dash:
		dashDuration -= delta
		if dashDuration <= 0 or !is_player_moving():
			dash = false
			dashDuration = dashCooldown
	else:
		dashTimer = max(0, dashTimer - delta)
		
		
		
# called when an input is detected
func _input(event):
	if event is InputEventMouseMotion:
		mouseDelta = event.relative


func is_player_moving():
	return vel.x != 0
	

	

