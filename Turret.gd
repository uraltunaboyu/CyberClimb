extends Enemy

@onready var head = $Head
@onready var collision = $TurretCollider
@onready var bulletScene = preload("res://scenes/Bullet.tscn")
@onready var barrel = $Head/Barrel

var detected: bool = false
var shooting: bool = false
var rot_speed: float = 0.3 # In radians/s
var i = 0

var bullet_speed = 15
var bullet_damage_min = 1
var bullet_damage_max = 3
var spread_angle:float = 0.06 # Cone with this angle (radians)
var bullet_life = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	collider_name = "TurretCollider"
	max_health = 100
	cur_health = max_health
	moveSpeed = 0
	
	atk_damage = 1.0
	attackRate = 15
	attackRange = 10.0
	ap.play("Idle")

func _physics_process(delta):
	var angle_stuff = angle_to_obj(player.position)
	var rot_dir = deg_to_rad(angle_stuff[0])
	if detected:
		if abs(rot_dir) > 0.06:
			if angle_stuff[1] > 0:
				head.rotate_y(rot_speed*delta)
				#print("rotating counterclockwise")
			else:
				head.rotate_y(rot_speed*delta*sign(angle_stuff[1]))
				#print("rotating clockwise")
		i += delta
		if shooting && i > 1/attackRate:
			make_bullet()
			i = 0
		
func angle_to_obj(obj_position:Vector3):
	var new_pos: Vector3 = head.to_local(obj_position)
	var no_y_pos: Vector2 = Vector2(new_pos[0], new_pos[2]).normalized()
	var dot = Vector2(1,0).normalized().dot(no_y_pos)
	return [rad_to_deg(acos(dot))-180, no_y_pos[1]]
	
func make_bullet():
	var bullet = bulletScene.instantiate()
	bullet.initialize(bullet_speed, randi_range(bullet_damage_min, bullet_damage_max), bullet_life)
	
	get_node("/root/MainScene").add_child(bullet)
	bullet.global_transform = barrel.global_transform
	
	var angle_x = randfn(0, spread_angle/1.5)
	var angle_y = randfn(0, spread_angle/1.5)
	
	bullet.rotate_object_local(Vector3(1,0,0), angle_x)
	bullet.rotate_object_local(Vector3(0,1,0), angle_y)

func _on_sights_body_entered(body: PhysicsBody3D):
	if body.is_in_group("Player"):
		print("Player Spotted!")
		detected = true

func _on_sights_body_exited(body):
	if body.is_in_group("Player"):
		print("Lost the player!")
		detected = false

func _on_shoots_body_entered(body):
	if body.is_in_group("Player"):
		print("Engaging Player!")
		shooting = true

func _on_shoots_body_exited(body):
	if body.is_in_group("Player"):
		print("Player out of spread range!")
		shooting = false
