class_name MovementController extends Node3D

enum MovementState {
	STOPPED,
	MOVING,
	DASHING,
	JUMPING,
	FALLING,
	#GLIDING,
	DOUBLEJUMPING,
	AIRDASHING,
	WALLRUNNING,
}

const MOVEMENT_STATE_NAMES = {
	MovementState.STOPPED : "STOPPED",
	MovementState.MOVING : "MOVING",
	MovementState.DASHING : "DASHING",
	MovementState.JUMPING : "JUMPING",
	MovementState.FALLING : "FALLING",
	#MovementState.GLIDING : "GLIDING",
	MovementState.DOUBLEJUMPING : "DOUBLEJUMPING",
	MovementState.AIRDASHING : "AIRDASHING",
	MovementState.WALLRUNNING : "WALLRUNNING"
}

var vel: Vector3

#wallrun
const WALLRUN_SPEED_THRESHOLD = 2.0
const WALLRUN_MIN_STAMINA = 20
var wallDirection: int

var jumpTimer: Timer
var jumpReady = true
var doublejumpReady = true

# dash
var dashReady = true
var dashCooldown: Timer
var dashTimer: Timer

# stamina
var stamina: float = PlayerState.maxStamina:
	set = _set_stamina
var isRecovering = false
var recoveryTimer: Timer

var currentState: MovementState
var prevState: MovementState
var playerRef: CharacterBody3D

var gravity : float = 9.81

const FLOOR_DISTANCE_THRESHOLD: float = 0.35

@onready var _down: RayCast3D = get_node("Down")
@onready var _left: RayCast3D = get_node("Left")
@onready var _right: RayCast3D = get_node("Right")

func _ready():
	currentState = MovementState.STOPPED
	vel = Vector3(0, 0, 0)
	
	recoveryTimer = Timer.new()
	add_child(recoveryTimer)
	
	recoveryTimer.wait_time = PlayerState.recovery_delay
	recoveryTimer.one_shot = true
	recoveryTimer.timeout.connect(func(): isRecovering = true)
	
	dashTimer = Timer.new()
	add_child(dashTimer)
	dashCooldown = Timer.new()
	add_child(dashCooldown)
	jumpTimer = Timer.new()
	add_child(jumpTimer)
	
	jumpTimer.wait_time = PlayerState.jump_cooldown
	jumpTimer.one_shot = true
	jumpTimer.timeout.connect(post_jump_recovery)
	
	dashTimer.wait_time = PlayerState.dash_duration
	dashTimer.one_shot = true
	dashTimer.timeout.connect(start_dash_cooldown)
	
	dashCooldown.wait_time = PlayerState.dash_cooldown_duration
	dashCooldown.one_shot = true
	dashCooldown.timeout.connect(post_dash_recovery)
	
func _process(_delta):
	if currentState == MovementState.WALLRUNNING:
		stamina -= PlayerState.wallrun_cost
	if isRecovering:
		stamina += PlayerState.recovery_rate
		stamina = min(stamina, PlayerState.maxStamina)
		isRecovering = stamina != PlayerState.maxStamina
		
func _set_stamina(val: float):
	if val < stamina:
		reset_recovery_timer()
	stamina = val
	PlayerState.stamina = stamina	
	
func _is_far_from_floor() -> bool:
	if not _down.is_colliding(): return true
	return global_position.distance_to(_down.get_collision_point()) < FLOOR_DISTANCE_THRESHOLD
	
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
	
func can_wallrun() -> bool:
	if PlayerState.wallrun_enabled == false:
		return false
	if not (playerRef.is_on_wall_only() and _is_far_from_floor()):
		return false
	if get_horizontal_magnitude(vel) < WALLRUN_SPEED_THRESHOLD:
		Log.Debug("Cannot wallrun while so slow")
		return false
	if stamina < WALLRUN_MIN_STAMINA:
		Log.Debug("Cannot wallrun without stamina")
		return false
	
	var input = get_input_vector()
	var wall_normal = playerRef.get_wall_normal()
	var wall_normal_2d = Vector2(wall_normal.x, wall_normal.z)
	var wall_angle = input.angle_to(wall_normal_2d)
	
	return (wall_angle != PI/2) && (wall_angle < PI/4 || wall_angle > 3*PI/4)
	
func can_dash() -> bool:
	return dashReady and stamina >= PlayerState.dash_cost
	
func can_jump() -> bool:
	return jumpReady and stamina >= PlayerState.jump_cost
	
func can_doublejump() -> bool:
	return doublejumpReady and stamina >= PlayerState.jump_cost	
	
func start_dash_cooldown():
	dashReady = false
	dashCooldown.start()
	
func start_dash():
	currentState = MovementState.DASHING
	stamina -= PlayerState.dash_cost
	
func start_airdash():
	if PlayerState.airdash_enabled == false:
		return
	# might change later
	start_dash()
	
func start_jump():
	currentState = MovementState.JUMPING
	stamina -= PlayerState.jump_cost
	reset_recovery_timer()
	
func post_dash_recovery():
	dashReady = true
	reset_recovery_timer()
	
func post_jump_recovery():
	jumpReady = true
	reset_recovery_timer()
	
func reset_recovery_timer():
	recoveryTimer.stop()
	recoveryTimer.wait_time = PlayerState.recovery_delay
	recoveryTimer.start()
	
func get_input_vector() -> Vector2:
	# movement inputs
	var input = Vector2()
	if Input.is_action_pressed("move_forward"):
		input.y -= 1
	if Input.is_action_pressed("move_backward"):
		input.y += 1
	if Input.is_action_pressed("move_left"):
		input.x -= 1
	if Input.is_action_pressed("move_right"):
		input.x += 1
		
	return input.normalized()
	
func get_horizontal_magnitude(vec: Vector3) -> float:
	return sqrt(vec.x * vec.x + vec.z * vec.z)
	
func calculate_movement_vector(delta) -> Vector3:
	UIController.set_movement_state(get_current_state())
	vel.x = 0
	vel.z = 0
	var input = get_input_vector()
	
	# get the forward and right directions
	var forward = playerRef.global_transform.basis.z
	var right = playerRef.global_transform.basis.x
	
	var relativeDir = (forward * input.y + right * input.x)
	
	if currentState != MovementState.DASHING && currentState != MovementState.AIRDASHING:
		vel.x = relativeDir.x * PlayerState.move_speed
		vel.z = relativeDir.z * PlayerState.move_speed
	else:
		if prevState != currentState: 
			dashTimer.start()
		vel.x = relativeDir.x * PlayerState.dash_speed
		vel.z = relativeDir.z * PlayerState.dash_speed
	
	# apply gravity. handles wether it is glide_gravity or regular
	if (currentState == MovementState.FALLING 
		or currentState == MovementState.JUMPING 
		or currentState == MovementState.DOUBLEJUMPING):
		vel.y -= gravity * delta
	elif currentState == MovementState.DASHING:
		vel.y -= gravity * delta / 2
	#elif currentState == MovementState.GLIDING:
		#vel.y -= PlayerState.glide_gravity * delta
		#vel.x = vel.x * 2
		#vel.z = vel.z * 2
	elif currentState == MovementState.WALLRUNNING:
		vel.y = 0
		
	#if currentState == MovementState.GLIDING:
		#vel.x = vel.x * PlayerState.glide_speed_mult
		#vel.z = vel.z * PlayerState.glide_speed_mult
		
	if (prevState != MovementState.JUMPING and
	prevState != MovementState.FALLING 
	 and currentState == MovementState.JUMPING):
		vel.y = PlayerState.jump_force
		jumpReady = false
		doublejumpReady = true
		jumpTimer.start()
		
	if ((prevState == MovementState.JUMPING or prevState == MovementState.FALLING)
	 and jumpReady == false and doublejumpReady == true 
	 and currentState == MovementState.DOUBLEJUMPING
	 and PlayerState.double_jump_enabled):
		doublejumpReady = false
		vel.y = PlayerState.jump_force
		jumpTimer.start()
		
	if prevState == MovementState.WALLRUNNING && currentState != MovementState.WALLRUNNING:
		Log.Debug("Disengaging from wall")
		var wall_normal: Vector3 = playerRef.get_wall_normal()
		var flat_wall_normal: Vector2 = Vector2(wall_normal.x, wall_normal.z) * 20
		vel.x = flat_wall_normal.x
		vel.z = flat_wall_normal.y
		
	return vel
	
func get_lean_direction() -> float:
	if not currentState == MovementState.WALLRUNNING:
		return 0.0
	else:
		if _left.is_colliding() and not _right.is_colliding():
			return -1
		elif not _left.is_colliding() and _right.is_colliding():
			return 1
		elif _left.is_colliding() and _right.is_colliding():
			var left_distance = global_position.distance_to(_left.get_collision_point())
			var right_distance = global_position.distance_to(_right.get_collision_point())
			return -1 if left_distance > right_distance else 1
		else:
			Log.Warn("State is WALLRUNNING but not close to any walls!")
			return 0.0

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
			elif not playerRef.is_on_floor():
				currentState = MovementState.FALLING
		MovementState.MOVING:
			if not playerRef.is_on_floor():
				currentState = MovementState.FALLING
			elif not is_movement_pressed() and \
			not is_jump_pressed() and \
			not is_dash_pressed():
				currentState = MovementState.STOPPED
			elif not is_jump_pressed() and \
			not is_dash_pressed():
				currentState = MovementState.MOVING
			elif not is_dash_pressed() and can_jump():
				start_jump()
			elif is_dash_pressed() and can_dash():
				start_dash()
		MovementState.JUMPING:
			if velocity.y <= 0:
				currentState = MovementState.FALLING
			if playerRef.is_on_floor():
				if get_horizontal_magnitude(velocity) == 0:
					currentState = MovementState.STOPPED
				else:
					currentState = MovementState.MOVING
			elif is_dash_pressed() and can_dash():
				start_airdash()
			elif is_jump_pressed() and can_doublejump():
				currentState = MovementState.DOUBLEJUMPING
			elif can_wallrun():
				currentState = MovementState.WALLRUNNING
		MovementState.FALLING:
			if playerRef.is_on_floor():
				if get_horizontal_magnitude(velocity) == 0:
					currentState = MovementState.STOPPED
				else:
					currentState = MovementState.MOVING
			elif is_dash_pressed() and can_dash():
				start_airdash()
			elif can_wallrun():
				currentState = MovementState.WALLRUNNING
			elif is_jump_pressed() and can_doublejump():
				currentState = MovementState.DOUBLEJUMPING
		MovementState.DASHING:
			if !dashReady:
				if get_horizontal_magnitude(velocity) == 0:
					currentState = MovementState.STOPPED
				else:
					currentState = MovementState.MOVING
			elif is_jump_pressed() and can_jump():
				start_jump()
			elif can_wallrun():
				currentState = MovementState.WALLRUNNING
		MovementState.AIRDASHING:
			if !dashReady:
				if playerRef.is_on_floor():
					if get_horizontal_magnitude(velocity) == 0:
						currentState = MovementState.STOPPED
					else:
						currentState = MovementState.MOVING
				else:
					currentState = MovementState.FALLING
			elif can_wallrun():
				currentState = MovementState.WALLRUNNING
		MovementState.DOUBLEJUMPING:
			if velocity.y <= 0:
				currentState = MovementState.FALLING
			if playerRef.is_on_floor():
				if get_horizontal_magnitude(velocity) == 0:
					currentState = MovementState.STOPPED
				else:
					currentState = MovementState.MOVING
			elif is_dash_pressed() and can_dash():
				start_airdash()
			elif can_wallrun():
				currentState = MovementState.WALLRUNNING
		MovementState.WALLRUNNING:
			if not can_wallrun():
				reset_recovery_timer()
				if not playerRef.is_on_floor():
					currentState = MovementState.FALLING
			elif is_jump_pressed() and can_jump():
				Log.Info("Walljump")
				start_jump()
			elif get_horizontal_magnitude(velocity) == 0:
					currentState = MovementState.STOPPED
