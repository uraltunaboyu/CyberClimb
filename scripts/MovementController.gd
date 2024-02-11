class_name MovementController extends Node

enum MovementState {
	STOPPED,
	MOVING,
	DASHING,
	JUMPING,
	FALLING,
	GLIDING,
	AIRDASHING,
	WALLRUNNING
}

const MOVEMENT_STATE_NAMES = {
	MovementState.STOPPED : "STOPPED",
	MovementState.MOVING : "MOVING",
	MovementState.DASHING : "DASHING",
	MovementState.JUMPING : "JUMPING",
	MovementState.FALLING : "FALLING",
	MovementState.GLIDING : "GLIDING",
	MovementState.AIRDASHING : "AIRDASHING",
	MovementState.WALLRUNNING : "WALLRUNNING"
}

var vel: Vector3

#wallrun
var wallNormal

var jumpTimer: Timer
var jumpCooldown = 1.0
var jumpForce : float = 12
var canJump = true

# dash
var canDash = true
var dashSpeed: float = 20.0
var dashDuration: float = 2.0
var dashCooldown: Timer
var dashCooldownDuration = 3.0
var dashTimer: Timer

var currentState: MovementState
var prevState: MovementState
var playerRef: CharacterBody3D

# physics
var moveSpeed : float = 5.0

#slow descent for glide
var glideGravity: float = 1.0
var glideSpeedMult: float = 1.5

var gravity : float = 12


func _ready():
	currentState = MovementState.STOPPED
	vel = Vector3(0, 0, 0)
	
	dashTimer = Timer.new()
	add_child(dashTimer)
	dashCooldown = Timer.new()
	add_child(dashCooldown)
	jumpTimer = Timer.new()
	add_child(jumpTimer)
	
	jumpTimer.wait_time = jumpCooldown
	jumpTimer.one_shot = true
	jumpTimer.timeout.connect(func(): canJump = true)
	
	dashTimer.wait_time = dashDuration
	dashTimer.one_shot = true
	dashTimer.timeout.connect(start_dash_cooldown)
	
	dashCooldown.wait_time = dashCooldownDuration
	dashCooldown.one_shot = true
	dashCooldown.timeout.connect(func(): canDash = true)
	
func set_player_ref(player: CharacterBody3D):
	playerRef = player
	
func get_current_state() -> String:
	return MOVEMENT_STATE_NAMES[currentState];

func is_movement_pressed() -> bool:
	return Input.is_action_pressed("move_forward") \
	|| Input.is_action_pressed("move_backward") \
	|| Input.is_action_pressed("move_left") \
	|| Input.is_action_pressed("move_right")
	
func is_jump_pressed() -> bool:
	return Input.is_action_just_pressed("jump")
	
func is_dash_pressed() -> bool:
	return Input.is_action_just_pressed("dash")
	
func can_start_wallrunning() -> bool:
	# TODO: some magic to see if player is moving
	# perpendicular to wall
	return playerRef.is_on_wall()
	
func start_dash_cooldown():
	canDash = false
	dashCooldown.start()
	
func calculate_movement_vector(delta) -> Vector3:
	var input = Vector2()
	vel.x = 0
	vel.z = 0

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
	var forward = playerRef.global_transform.basis.z
	var right = playerRef.global_transform.basis.x
	
	var relativeDir = (forward * input.y + right * input.x)
	
	if currentState != MovementState.DASHING && currentState != MovementState.AIRDASHING:
		vel.x = relativeDir.x * moveSpeed
		vel.z = relativeDir.z * moveSpeed
	else:
		if prevState != currentState: 
			dashTimer.start()
		vel.x = relativeDir.x * dashSpeed
		vel.z = relativeDir.z * dashSpeed
	
	# apply gravity. handles wether it is glideGravity or regular
	if currentState != MovementState.GLIDING && currentState != MovementState.WALLRUNNING:
		vel.y -= gravity * delta
	elif currentState == MovementState.GLIDING:
		vel.y -= glideGravity * delta
		vel.x = vel.x * 2
		vel.z = vel.z * 2
	elif currentState == MovementState.WALLRUNNING:
		vel.y = 0
		
	if currentState == MovementState.GLIDING:
		vel.x = vel.x * glideSpeedMult
		vel.z = vel.z * glideSpeedMult
		
	if currentState == MovementState.JUMPING && playerRef.is_on_floor() && canJump:
		vel.y = jumpForce
		canJump = false
		jumpTimer.start()
		
	
	return vel

# get the current input and use currentState to calculate next state
# and update self
func poll(velocity: Vector3):
	prevState = currentState
	match currentState:
		MovementState.STOPPED:
			if is_movement_pressed():
				currentState = MovementState.MOVING
			elif is_jump_pressed() and canJump:
				currentState = MovementState.JUMPING
			elif is_dash_pressed() and canDash:
				currentState = MovementState.DASHING
		MovementState.MOVING:
			if not is_movement_pressed() and \
			not is_jump_pressed() and \
			not is_dash_pressed():
				currentState = MovementState.STOPPED
			elif not is_jump_pressed() and \
			not is_dash_pressed():
				currentState = MovementState.MOVING
			elif not is_dash_pressed() and canJump:
				currentState = MovementState.JUMPING
			elif canDash:
				currentState = MovementState.DASHING
		MovementState.JUMPING:
			if velocity.y <= 0:
				currentState = MovementState.FALLING
			if playerRef.is_on_floor():
				if velocity.x == 0:
					currentState = MovementState.STOPPED
				else:
					currentState = MovementState.MOVING
			elif is_dash_pressed() and canDash:
				currentState = MovementState.AIRDASHING
			elif can_start_wallrunning():
				currentState = MovementState.WALLRUNNING
		MovementState.FALLING:
			if playerRef.is_on_floor():
				if velocity.x == 0:
					currentState = MovementState.STOPPED
				else:
					currentState = MovementState.MOVING
			elif is_dash_pressed() and canDash:
				currentState = MovementState.AIRDASHING
			elif can_start_wallrunning():
				currentState = MovementState.WALLRUNNING
			elif is_jump_pressed():
				currentState = MovementState.GLIDING
		MovementState.DASHING:
			if !canDash:
				if velocity.x == 0:
					currentState = MovementState.STOPPED
				else:
					currentState = MovementState.MOVING
			elif is_jump_pressed() and canJump:
				currentState = MovementState.JUMPING
		MovementState.AIRDASHING:
			if !canDash:
				if playerRef.is_on_floor():
					if velocity.x == 0:
						currentState = MovementState.STOPPED
					else:
						currentState = MovementState.MOVING
				else:
					currentState = MovementState.FALLING
			elif playerRef.is_on_wall_only():
				currentState = MovementState.WALLRUNNING
		MovementState.GLIDING:
			if playerRef.is_on_floor():
				if velocity.x == 0:
					currentState = MovementState.STOPPED
				else:
					currentState = MovementState.MOVING
			elif playerRef.is_on_wall_only():
				currentState = MovementState.WALLRUNNING
		MovementState.WALLRUNNING:
			if not playerRef.is_on_wall_only():
				if not playerRef.is_on_floor():
					currentState = MovementState.FALLING
				else:
					if velocity.x == 0:
						currentState = MovementState.STOPPED
					else:
						currentState = MovementState.MOVING
			elif is_jump_pressed() and canJump:
				currentState = MovementState.JUMPING
