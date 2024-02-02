extends CharacterBody3D

# stats
var curHp : int = 10
var maxHp : int = 10
var score: int = 0

# physics
var moveSpeed : float = 5.0
var dashSpeed: float = 10.0
var jumpForce : float = 5.0

#slow descent for glide
var glideGravity: float = 1.0
var glideSpeedMult: float = 1.5

var gravity : float = 12.0
var jumpCount: int = 0
var glide = false
var dashing = false

# cam look
var minLookAngle : float = -90.0
var maxLookAngle : float = 90.0
var lookSensitivity : float = 10.0

# vectors
var vel : Vector3 = Vector3()
var mouseDelta : Vector2 = Vector2()

# components
@onready var camera : Camera3D = get_node("Camera3D")
@onready var ui : Node = get_node("/root/MainScene/CanvasLayer/UI")

@onready var primarySlot: Node3D = get_node("Camera3D/GunSlotPrimary")
#@onready var secondarySlot: Node = get_node("Camera3D/GunSlotSecondary") TODO

func _ready ():
	# hide and lock the mouse cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# set the UI
	ui.update_health_bar(curHp, maxHp)
	ui.update_ammo_text(primarySlot.get_ammo_count())

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
	
	# set the velocity
	vel.x = relativeDir.x * moveSpeed
	vel.z = relativeDir.z * moveSpeed
	
	# apply gravity. handles wether it is glideGravity or regular
	if !glide:
		vel.y -= gravity * delta
	else:
		vel.y -= glideGravity * delta
		
	#handles dash. dash when you hold shift. Incomplete want to make it a burst of speed not an infinite dash.
	if Input.is_action_pressed("dash"):
		dashing = true
	
	if dashing:
		var dashDirection = (right * input.x + forward * input.y).normalized()
		vel += dashDirection * dashSpeed
		
	if !Input.is_action_pressed("dash"):
		dashing = false
		
		
	if glide:
		vel.x = vel.x * glideSpeedMult
	
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
		
	
	
	

# called every frame	

func _process(delta):
	# rotate the camera along the x axis
	camera.rotation_degrees.x -= mouseDelta.y * lookSensitivity * delta
	
	# clamp camera x rotation axis
	camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, minLookAngle, maxLookAngle)
	
	# rotate the player along their y axis
	rotation_degrees.y -= mouseDelta.x * lookSensitivity * delta
	
	# reset the mouse delta vector
	mouseDelta = Vector2()
	
	# check to see if we have shot
	if Input.is_action_just_pressed("shoot"):
		shoot()
		
# called when an input is detected
func _input(event):
	if event is InputEventMouseMotion:
		mouseDelta = event.relative

# called when we press the shoot button - spawn a new bullet	
func shoot ():
	primarySlot.attack()
	ui.update_ammo_text(primarySlot.get_ammo_count())

# called when an enemy damages us
func take_damage (damage):
	curHp -= damage
	
	ui.update_health_bar(curHp, maxHp)
	
	if curHp <= 0:
		die()

# called when our health reaches 0	
func die ():
	get_tree().reload_current_scene()
	
func add_health (amount):
	curHp += amount
	
	if curHp > maxHp:
		curHp = maxHp
		
	ui.update_health_bar(curHp, maxHp)
	
func add_ammo (amount):
	primarySlot.add_ammo_count(amount)
