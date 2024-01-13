extends 'res://Movement.gd'

# stats
var curHp : int = 10
var maxHp : int = 10
var ammo : int = 30
var score: int = 0

# cam look
var minLookAngle : float = -90.0
var maxLookAngle : float = 90.0
var lookSensitivity : float = 10.0


# components
@onready var camera : Camera3D = get_node("Camera3D")
@onready var muzzle : Node3D = get_node("Camera3D/Muzzle")
@onready var bulletScene = load("res://Scenes/Bullet.tscn")
@onready var ui : Node = get_node("/root/MainScene/CanvasLayer/UI")

func _ready ():
	# hide and lock the mouse cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# set the UI
	ui.update_health_bar(curHp, maxHp)
	ui.update_ammo_text(ammo)


func _process(delta):
	super._process(delta)
	# rotate the camera along the x axis
	camera.rotation_degrees.x -= mouseDelta.y * lookSensitivity * delta
	
	# clamp camera x rotation axis
	camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, minLookAngle, maxLookAngle)
	
	# rotate the player along their y axis
	rotation_degrees.y -= mouseDelta.x * lookSensitivity * delta
	
	# reset the mouse delta vector
	mouseDelta = Vector2()
	
	# check to see if we have shot
	if Input.is_action_just_pressed("shoot") and ammo > 0:
		shoot()
		
		
# called when an input is detected
func _input(event):
	if event is InputEventMouseMotion:
		mouseDelta = event.relative

# called when we press the shoot button - spawn a new bullet	
func shoot ():
	var bullet = bulletScene.instantiate()
	get_node("/root/MainScene").add_child(bullet)
	
	bullet.global_transform = muzzle.global_transform
	
	ammo -= 1
	
	ui.update_ammo_text(ammo)

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
	ammo += amount
	ui.update_ammo_text(ammo)

func is_player_moving():
	return vel.x != 0
	

