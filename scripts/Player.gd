extends CharacterBody3D

# stats
var curHp : int = 100
var maxHp : int = 100
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
@onready var ui : Node = get_node("../CanvasLayer/UI")
@onready var primarySlot: Node3D = get_node("Camera3D/GunSlotPrimary")
#@onready var secondarySlot: Node = get_node("Camera3D/GunSlotSecondary") TODO
@onready var movementController = get_node("MovementController")

func _ready ():
	# hide and lock the mouse cursor
	GameState.set_state_playing()
	
	PlayerState.ammo = primarySlot.get_ammo_count()
	
	movementController.set_player_ref(self)

# called 60 times a second
func _physics_process(delta):
	movementController.poll(velocity)
	
	# move the player
	set_velocity(movementController.calculate_movement_vector(delta))
	move_and_slide()

func _process(delta):
	camera.rotation_degrees.x -= mouseDelta.y * lookSensitivity * delta
	camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, minLookAngle, maxLookAngle)
	rotation_degrees.y -= mouseDelta.x * lookSensitivity * delta
	mouseDelta = Vector2()
	
func _input(event):
	if event is InputEventMouseMotion:
		mouseDelta = event.relative

# called when an enemy damages us
func take_damage (damage):
	curHp -= damage
	
	PlayerState.hp = curHp
	
	if curHp <= 0:
		die()

# called when our health reaches 0	
func die ():
	get_tree().reload_current_scene()
	
func add_health (amount):
	curHp += amount
	
	if curHp > maxHp:
		curHp = maxHp
		
	PlayerState.hp = curHp
	
func add_ammo (amount):
	if primarySlot.equipped_gun:
		primarySlot.add_ammo(int(amount))
	
func _on_button_interacted(target_scene):
	primarySlot.set_equipped_gun(target_scene)
	
func remove_weapon(_nothing):
	primarySlot.remove_weapon()
