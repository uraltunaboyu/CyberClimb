extends PathfindingEnemy

const FIRE_RANGE = 10.0
const FIRE_RATE = 5.0
const BULLET_SPEED = 9.0
const BULLET_DAMAGE_MIN = 2
const BULLET_DAMAGE_MAX = 5
const BULLET_LIFETIME = 1.0
const SPREAD_ANGLE = 0.03

var _last_fired: float = 0.0

var bullet_scene = load("res://scenes/projectiles/bullet.tscn")

@onready var _cannon: MeshInstance3D = $Model/Drone/DroneCannon
@onready var _muzzle: Node3D = $Model/Drone/DroneCannon/Muzzle

func _ready():
	max_health = 250
	cur_health = max_health

func _process(delta):
	_cannon.look_at(player.global_position, Vector3.UP, true)
	_cannon.rotate_x(PI/8)
	set_navigation_target(player.global_position)
	if global_position.distance_to(player.global_position) < FIRE_RANGE \
	and _last_fired >= 1/FIRE_RATE:
		_last_fired = 0
		_make_bullet()
	_last_fired += delta

func _physics_process(delta):
	navigate_to_target(delta)

func _make_bullet():
	var bullet = bullet_scene.instantiate()
	bullet.initialize(BULLET_SPEED, randi_range(BULLET_DAMAGE_MIN, BULLET_DAMAGE_MAX), BULLET_LIFETIME)
	
	get_tree().root.add_child(bullet)
	bullet.global_transform = _muzzle.global_transform
	
	var angle_x = randfn(0, SPREAD_ANGLE/1.5)
	var angle_y = randfn(0, SPREAD_ANGLE/1.5)
	
	bullet.rotate_object_local(Vector3(1,0,0), angle_x)
	bullet.rotate_object_local(Vector3(0,1,0), angle_y)
