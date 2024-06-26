extends CharacterBody3D

@export var death_overlay_scene: PackedScene
# stats
var maxHp : int = PlayerState.maxHp
var curHp = maxHp
var ammo : int = 30

# cam look
var minLookAngle : float = -90.0
var maxLookAngle : float = 90.0
var lookSensitivity : float = 10.0

# vectors
var mouseDelta : Vector2 = Vector2()
var fall: Vector3 = Vector3()

# leaning
const LEAN_AMOUNT_RAD = deg_to_rad(10.0)
var leanTarget: float = 0.0
var leanElapsed: float = 0.0

var _disabled = false

# components
@onready var camera : Camera3D = get_node("PivotPoint/Camera3D")
@onready var ui : Node = get_node("../CanvasLayer/UI")
@onready var primarySlot: Node3D = get_node("PivotPoint/Camera3D/GunSlotPrimary")
@onready var movementController = get_node("MovementController")
@onready var pivotPoint: Node3D = get_node("PivotPoint")

func _ready ():
	Log.Debug(get_path())
	GameState.set_state_playing()
	load_state()
	UIController._initialize()
	movementController.set_player_ref(self)

func _physics_process(delta):
	if _disabled: return
	movementController.poll(velocity)
	
	set_velocity(movementController.calculate_movement_vector(delta))
	
	_lean(delta, false)
	move_and_slide()

func _process(delta):
	if _disabled: return
	camera.rotation_degrees.x -= mouseDelta.y * lookSensitivity * delta
	camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, minLookAngle, maxLookAngle)
	rotation_degrees.y -= mouseDelta.x * lookSensitivity * delta
	mouseDelta = Vector2()
	
func _input(event):
	if event is InputEventMouseMotion:
		mouseDelta = event.relative
	if Debug.DEBUG_MODE and event is InputEventKey:
		if Input.is_key_label_pressed(KEY_K):
			die()

func _lean(delta, lean_right: bool):
	var rotateAngle: float = LEAN_AMOUNT_RAD * movementController.get_lean_direction()
	if leanTarget != rotateAngle:
		leanTarget = rotateAngle
		leanElapsed = 0.0
	
	var newRotation: float = lerp_angle(pivotPoint.global_rotation.z, rotateAngle, leanElapsed)
	leanElapsed = min(leanElapsed + delta, 1.0)
	pivotPoint.global_rotation.z = newRotation

# called when an enemy damages us
func take_damage (damage):
	curHp -= damage
	PlayerState.hp = curHp
	
	if curHp <= 0:
		die()

func die():
	_disabled = true
	var death_overlay = death_overlay_scene.instantiate()
	death_overlay.set_text("Defeat")
	death_overlay.set_callback(GameState.reset)
	
	add_sibling(death_overlay)
	var death_tween = create_tween()
	
	death_tween.tween_property(pivotPoint, "rotation:x", PI/2, 0.8)
	
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
	
func add_upgrade(upgrade):
	PlayerState.add_upgrade(upgrade)

func load_state():
	curHp = PlayerState.hp
	maxHp = PlayerState.maxHp
	primarySlot.load_state()
