extends Interactable

@onready var rot_point = $RotationPoint
@onready var startYPos : float = rot_point.position.y
var bobHeight : float = 0.3
var bobSpeed : float = 0.2
var bobbingUp : bool = true

@export var Weapon : WeaponAttributes.Name

var rot_speed = PI/2

const WeaponOffsets = {
	WeaponAttributes.Name.PISTOL : Vector3(0, 0, 0),
	WeaponAttributes.Name.SHOTGUN : Vector3(0, 0, 0),
	WeaponAttributes.Name.ASSAULT_RIFLE : Vector3(0, 0.15, 0.4),
	WeaponAttributes.Name.BURST_RIFLE : Vector3(0, 0, 0),
}

func _ready():
	target_scene = WeaponAttributes.TO_NAME[Weapon]
	
	var weapon = load(WeaponAttributes.SCENE[Weapon]).instantiate()
	rot_point.add_child(weapon)
	weapon.global_position = rot_point.global_position + WeaponOffsets[Weapon]

func _process(delta):
	rot_point.rotate_y(delta*rot_speed)
	rot_point.position.y += (bobSpeed if bobbingUp == true else -bobSpeed) * delta
	if bobbingUp and rot_point.position.y > startYPos + bobHeight:
		bobbingUp = false
	elif !bobbingUp and rot_point.position.y < startYPos:
		bobbingUp = true
