class_name Gun extends Node3D

@onready var muzzle : Node3D = $Muzzle
@onready var bulletScene = preload("res://scenes/projectiles/bullet.tscn")
@onready var shot_timer : Timer = $Timer

@export var recoil_rotation_x : Curve
@export var recoil_rotation_z : Curve
@export var recoil_position_z : Curve
@export var recoil_amplitude := Vector3(1,1,1)
@export var lerp_speed : float = 1

var target_rot : Vector3
var target_pos : Vector3
var current_time : float

var ammoCount = 40
var bullet_speed = 15
var bullet_damage_min = 7
var bullet_damage_max = 11
var spread_angle:float = 0.06 # Cone with this angle (radians)
var bullet_life = 2
var shots_per_sec:float = 20

func _ready():
	target_rot.y = rotation.y
	current_time = 1

func _physics_process(delta):
	if current_time < 1 and recoil_rotation_z:
		current_time += delta
		position.z = lerp(position.z, target_pos.z, lerp_speed * delta)
		rotation.z = lerp(rotation.z, target_rot.z, lerp_speed * delta)
		rotation.x = lerp(rotation.x, target_rot.x, lerp_speed * delta)
		
		target_rot.z = recoil_rotation_z.sample(current_time) * recoil_amplitude.y
		target_rot.x = recoil_rotation_x.sample(current_time) * -recoil_amplitude.x
		target_pos.z = recoil_position_z.sample(current_time) * recoil_amplitude.z

func apply_recoil():
	recoil_amplitude.y *= -1 if randf() > 0.5 else 1
	target_rot.z = recoil_rotation_z.sample(0)
	target_rot.x = recoil_rotation_x.sample(0)
	target_pos.z = recoil_position_z.sample(0)
	current_time = 0	
	
func get_ammo_count():
	return ammoCount

func add_ammo_count(count):
	ammoCount += count
	
func make_bullet():
		var bullet = bulletScene.instantiate()
		bullet.initialize(bullet_speed, randi_range(bullet_damage_min, bullet_damage_max), bullet_life, null)
		
		get_tree().root.add_child(bullet)
		bullet.global_transform = muzzle.global_transform
		
		var angle_x = randfn(0, spread_angle/1.5)
		var angle_y = randfn(0, spread_angle/1.5)
		
		bullet.rotate_object_local(Vector3(1,0,0), angle_x)
		bullet.rotate_object_local(Vector3(0,1,0), angle_y)
