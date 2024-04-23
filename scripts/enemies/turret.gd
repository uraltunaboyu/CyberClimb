extends Enemy

@onready var head_rot = $Head_Rot
@onready var head = $Head_Rot/Head
@onready var collision = $EnemyCollider
@onready var bulletScene = preload("res://scenes/projectiles/bullet.tscn")
@onready var barrel = $Head_Rot/Head/Barrel
@onready var ap = $AnimationPlayer22
#This contains the idle animation if we can figure out how to use it w/o breaks

var detected: bool = false
var shooting: bool = false
var rot_speed: float = 1.2 # In radians/s
var i = 0

var bullet_speed = 15
var bullet_damage_min = 1
var bullet_damage_max = 3
var spread_angle:float = 0.06 # Cone with this angle (radians)
var bullet_life = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	collider_name = "EnemyCollider"
	max_health = 150
	cur_health = max_health
	moveSpeed = 0
	
	atk_damage = 1.0
	attackRate = 15
	attackRange = 10.0
	ap.play("Idle")

func _physics_process(delta):
	var angle_info = angle_to_obj(player.position)
	if not is_on_floor():
		velocity.y -= 9.81*delta
		move_and_slide()
	if detected:
		if abs(angle_info[0]) > 0.02:
			if angle_info[1] > 0:
				head_rot.rotate_y(rot_speed*delta)
				collision.rotate_y(rot_speed*delta)
			else:
				head_rot.rotate_y(rot_speed*delta*sign(angle_info[1]))
				collision.rotate_y(rot_speed*delta*sign(angle_info[1]))
		i += delta
		if shooting && i > 1/attackRate:
			make_bullet()
			i = 0
		
func angle_to_obj(obj_position:Vector3):
	var local_pos: Vector3 = head.to_local(obj_position)
	var no_y_pos: Vector2 = Vector2(local_pos[0], local_pos[2]).normalized()
	var dot = Vector2(1,0).normalized().dot(no_y_pos)
	return [acos(dot)-PI, no_y_pos[1]]
	
func make_bullet():
	var bullet = bulletScene.instantiate()
	bullet.initialize(bullet_speed, randi_range(bullet_damage_min, bullet_damage_max), bullet_life)
	
	get_tree().root.add_child(bullet)
	bullet.global_transform = barrel.global_transform
	
	var angle_x = randfn(0, spread_angle/1.5)
	var angle_y = randfn(0, spread_angle/1.5)
	
	bullet.rotate_object_local(Vector3(1,0,0), angle_x)
	bullet.rotate_object_local(Vector3(0,1,0), angle_y)

func _on_sights_body_entered(body: PhysicsBody3D):
	if body.is_in_group("Player"):
		Log.Debug("Player Spotted!")
		detected = true

func _on_sights_body_exited(body):
	if body.is_in_group("Player"):
		Log.Debug("Lost the player!")
		detected = false

func _on_shoots_body_entered(body):
	if body.is_in_group("Player"):
		Log.Debug("Engaging Player!")
		shooting = true

func _on_shoots_body_exited(body):
	if body.is_in_group("Player"):
		Log.Debug("Player out of spread range!")
		shooting = false

func die():
	alive = false
	set_physics_process(false)
	find_child(collider_name).queue_free()
	emit_signal("dead")
	GameState.enemies_killed += 1
	ap.stop()
	if death_ap and death_ap.has_animation("Death"):
		death_ap.play("Death")
	else:
		remove()
