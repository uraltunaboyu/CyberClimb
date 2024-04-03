extends CharacterBody3D

# stats
var curHp : int = 100
var maxHp : int = 100
var ammo : int = 30

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
@onready var movementController = get_node("MovementController")

func _ready ():
	GameState.set_state_playing()
	load_state()
	UIController._initialize()
	movementController.set_player_ref(self)

func _physics_process(delta):
	movementController.poll(velocity)
	
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

func die():
	PlayerState.reset()
	GameState.reset()
	
func add_health(amount):
	curHp += amount
	
	if curHp > maxHp:
		curHp = maxHp
		
	PlayerState.hp = curHp
	
func add_ammo(amount):
	if primarySlot.equipped_gun:
		primarySlot.add_ammo(int(amount))
	
func add_weapon(weapon_name):
	PlayerState.equipped_weapon = weapon_name
	primarySlot.set_equipped_gun(WeaponAttributes.SCENE[weapon_name])

func remove_weapon(_nothing):
	PlayerState.equipped_weapon = WeaponAttributes.Name.NONE
	primarySlot.remove_weapon()

func load_state():
	curHp = PlayerState.hp
	maxHp = PlayerState.maxHp
	primarySlot.load_state()
