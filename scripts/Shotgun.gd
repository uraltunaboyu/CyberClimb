class_name SemiAutoGun extends Node3D

@onready var muzzle : Node3D = $Muzzle
@onready var bulletScene = preload("res://scenes/Bullet.tscn")
@onready var shot_timer : Timer = $Timer

var ammoCount = 15
var bullet_speed = 18
var bullet_damage_min = 1
var bullet_damage_max = 5
var pellet_count = 30
var spread_angle:float = 0.25 # Cone with this angle (radians)
var bullet_life = 1
var rpm:float = 70

func _ready():
	shot_timer.wait_time = 60/rpm
	shot_timer.one_shot = true
	return
	
func attack():
	if ammoCount != 0 and shot_timer.is_stopped():
	
		for i in range(pellet_count):
			var bullet = bulletScene.instantiate()
			bullet.initialize(bullet_speed, randi_range(bullet_damage_min, bullet_damage_max), bullet_life)
			
			get_node("/root/MainScene").add_child(bullet)
			bullet.global_transform = muzzle.global_transform
			
			var angle_x = randfn(0, spread_angle/1.5)
			var angle_y = randfn(0, spread_angle/1.5)
			
			bullet.rotate_object_local(Vector3(1,0,0), angle_x)
			bullet.rotate_object_local(Vector3(0,1,0), angle_y)
		
		ammoCount -= 1
		shot_timer.start()
	
func get_ammo_count():
	return ammoCount

func add_ammo_count(count):
	ammoCount += count