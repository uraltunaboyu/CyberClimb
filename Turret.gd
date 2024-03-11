extends Enemy

@onready var head = $Head
@onready var collision = $CollisionPolygon3D

var detected: bool = false
var rot_speed: float = 1 # In radians/s

# Called when the node enters the scene tree for the first time.
func _ready():
	max_health = 100
	cur_health = max_health
	moveSpeed = 0
	
	atk_damage = 1.0
	attackRate = 5.0
	attackRange = 10.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	ap.play("Idle")

func _physics_process(delta):
	if detected:
		var player_dir = (head.global_transform - player.global_transform).normalized()
		print(head.rotation)
		print(head.rotation.angle_to(player.global_position))
		#var rotate_ang = 
		#print(rotate_ang)
		#if rotate_ang < 0.1:
		#	head.rotation += Vector3(0, rotate_ang / rot_speed * delta, 0)
		#if difference != 0:
		#	rotation += (difference / abs(difference)) * rot_speed*delta
		head.transform += Vector3(0, delta*rot_speed,0)
		collision.rotation += Vector3(0, delta*rot_speed,0)
	
func _on_sights_body_entered(body: PhysicsBody3D):
	if body.is_in_group("Player"):
		print("Player Spotted!")
		detected = true
		#var current_rot = Quaternion(transform.basis)
		#var player_pos = (player.global_transform.origin - global_transform.origin).normalized()
		#var target_rot = Quaternion(player_pos.basis)
		#target_dir = current_rot.slerp(target_rot, 0.1)

func _on_sights_body_exited(body):
	if body.is_in_group("Player"):
		detected = false
		
