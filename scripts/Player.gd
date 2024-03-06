extends CharacterBody3D

# stats
var curHp : int = 10
var maxHp : int = 10
var ammo : int = 30
var score: int = 0

# cam look
var minLookAngle : float = -90.0
var maxLookAngle : float = 90.0
var lookSensitivity : float = 10.0

# vectors
var mouseDelta : Vector2 = Vector2()
var fall: Vector3 = Vector3()

# components
@onready var camera : Camera3D = get_node("Camera3D")
@onready var ui : Node = get_node("/root/MainScene/CanvasLayer/UI")

@onready var primarySlot: Node3D = get_node("Camera3D/GunSlotPrimary")
#@onready var secondarySlot: Node = get_node("Camera3D/GunSlotSecondary") TODO
@onready var movementController = get_node("MovementController")

func _ready ():
	# hide and lock the mouse cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# set the UI
	ui.update_health_bar(curHp, maxHp)
	ui.update_ammo_text(primarySlot.get_ammo_count())
	
	movementController.set_player_ref(self)

# called 60 times a second
func _physics_process(delta):
	# exit if esc pressed
	if Input.is_action_pressed("exit"):
		get_tree().quit()
	
	movementController.poll(velocity)
	ui.update_movement_state(movementController.get_current_state())
	
	# move the player
	set_velocity(movementController.calculate_movement_vector(delta))
	move_and_slide()

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
