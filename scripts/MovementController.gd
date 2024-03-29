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
var jumpReady = true

# dash
var dashReady = true
var dashCooldown: Timer
var dashTimer: Timer

# stamina
var isRecovering = false
var recoveryTimer: Timer

var currentState: MovementState
var prevState: MovementState
var playerRef: CharacterBody3D

var gravity : float = 12

func _ready():
	currentState = MovementState.STOPPED
	vel = Vector3(0, 0, 0)
	
	recoveryTimer = Timer.new()
	add_child(recoveryTimer)
	
	recoveryTimer.wait_time = PlayerState.recoveryDelay
	recoveryTimer.one_shot = true
	recoveryTimer.timeout.connect(func(): isRecovering = true)
	
	dashTimer = Timer.new()
	add_child(dashTimer)
	dashCooldown = Timer.new()
	add_child(dashCooldown)
	jumpTimer = Timer.new()
	add_child(jumpTimer)
	
	jumpTimer.wait_time = PlayerState.jumpCooldown
	jumpTimer.one_shot = true
	jumpTimer.timeout.connect(post_jump_recovery)
	
	dashTimer.wait_time = PlayerState.dashDuration
	dashTimer.one_shot = true
	dashTimer.timeout.connect(start_dash_cooldown)
	
	dashCooldown.wait_time = PlayerState.dashCooldownDuration
	dashCooldown.one_shot = true
	dashCooldown.timeout.connect(post_dash_recovery)
	
func _process(_delta):
	if currentState == MovementState.WALLRUNNING:
		PlayerState.stamina -= PlayerState.wallrunCost
	if isRecovering:
		PlayerState.stamina += PlayerState.recoveryRate
		PlayerState.stamina = min(PlayerState.stamina, PlayerState.maxStamina)
		isRecovering = PlayerState.stamina != PlayerState.maxStamina
	
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
	
func can_dash() -> bool:
	return dashReady and PlayerState.stamina >= PlayerState.dashCost
	
func can_jump() -> bool:
	return jumpReady and PlayerState.stamina >= PlayerState.jumpCost
	
func start_dash_cooldown():
	dashReady = false
	dashCooldown.start()
	
func start_dash():
	currentState = MovementState.DASHING
	PlayerState.stamina -= PlayerState.dashCost
	
func start_airdash():
	# might change later
	start_dash()
	
func start_jump():
	currentState = MovementState.JUMPING
	PlayerState.stamina -= PlayerState.jumpCost
	reset_recovery_timer()
	
func post_dash_recovery():
	dashReady = true
	reset_recovery_timer()
	
func post_jump_recovery():
	jumpReady = true
	reset_recovery_timer()
	
func reset_recovery_timer():
	recoveryTimer.stop()
	recoveryTimer.wait_time = PlayerState.recoveryDelay
	recoveryTimer.start()
	
func calculate_movement_vector(delta) -> Vector3:
	UIController.set_movement_state(get_current_state())
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
		vel.x = relativeDir.x * PlayerState.moveSpeed
		vel.z = relativeDir.z * PlayerState.moveSpeed
	else:
		if prevState != currentState: 
			dashTimer.start()
		vel.x = relativeDir.x * PlayerState.dashSpeed
		vel.z = relativeDir.z * PlayerState.dashSpeed
	
	# apply gravity. handles wether it is glideGravity or regular
	if currentState != MovementState.GLIDING && currentState != MovementState.WALLRUNNING:
		vel.y -= gravity * delta
	elif currentState == MovementState.GLIDING:
		vel.y -= PlayerState.glideGravity * delta
		vel.x = vel.x * 2
		vel.z = vel.z * 2
	elif currentState == MovementState.WALLRUNNING:
		vel.y = 0
		
	if currentState == MovementState.GLIDING:
		vel.x = vel.x * PlayerState.glideSpeedMult
		vel.z = vel.z * PlayerState.glideSpeedMult
		
	if currentState == MovementState.JUMPING && playerRef.is_on_floor() && jumpReady:
		vel.y = PlayerState.jumpForce
		jumpReady = false
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
			elif is_jump_pressed() and jumpReady:
				start_jump()
			elif is_dash_pressed() and can_dash():
				start_dash()
		MovementState.MOVING:
			if not is_movement_pressed() and \
			not is_jump_pressed() and \
			not is_dash_pressed():
				currentState = MovementState.STOPPED
			elif not is_jump_pressed() and \
			not is_dash_pressed():
				currentState = MovementState.MOVING
			elif not is_dash_pressed() and can_jump():
				start_jump()
			elif can_dash():
				start_dash()
		MovementState.JUMPING:
			if velocity.y <= 0:
				currentState = MovementState.FALLING
			if playerRef.is_on_floor():
				if velocity.x == 0:
					currentState = MovementState.STOPPED
				else:
					currentState = MovementState.MOVING
			elif is_dash_pressed() and can_dash():
				start_airdash()
			elif can_start_wallrunning():
				currentState = MovementState.WALLRUNNING
		MovementState.FALLING:
			if playerRef.is_on_floor():
				if velocity.x == 0:
					currentState = MovementState.STOPPED
				else:
					currentState = MovementState.MOVING
			elif is_dash_pressed() and can_dash():
				start_airdash()
			elif can_start_wallrunning():
				currentState = MovementState.WALLRUNNING
			elif is_jump_pressed():
				currentState = MovementState.GLIDING
		MovementState.DASHING:
			if !dashReady:
				if velocity.x == 0:
					currentState = MovementState.STOPPED
				else:
					currentState = MovementState.MOVING
			elif is_jump_pressed() and can_jump():
				start_jump()
		MovementState.AIRDASHING:
			if !dashReady:
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
				reset_recovery_timer()
				if not playerRef.is_on_floor():
					currentState = MovementState.FALLING
				else:
					if velocity.x == 0:
						currentState = MovementState.STOPPED
					else:
						currentState = MovementState.MOVING
			elif is_jump_pressed() and can_jump():
				start_jump()
