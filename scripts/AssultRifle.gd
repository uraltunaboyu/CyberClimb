class_name AutoGun extends Node3D

@onready var muzzle : Node3D = $Muzzle
@onready var bulletScene = preload("res://scenes/Bullet.tscn")
@onready var shot_timer : Timer = $Timer

var ammoCount = 100
var bullet_speed = 10
var bullet_damage_min = 4
var bullet_damage_max = 7
var spread_angle:float = 0.08 # Cone with this angle (radians)
var bullet_life = 2
var shots_per_sec = 10.0

func _ready():
	shot_timer.wait_time = 1/shots_per_sec
	shot_timer.one_shot = true
	return
	
func attack():
	if ammoCount != 0 and shot_timer.is_stopped():

		var bullet = bulletScene.instantiate()
		bullet.initialize(bullet_speed, randi_range(bullet_damage_min, bullet_damage_max), bullet_life)
		
		get_node("/root/MainScene").add_child(bullet)
		bullet.global_transform = muzzle.global_transform
		
		var angle_x = randf_range(spread_angle, -spread_angle)
		var angle_y = randf_range(spread_angle, -spread_angle)
		
		bullet.rotate_object_local(Vector3(1,0,0), angle_x)
		bullet.rotate_object_local(Vector3(0,1,0), angle_y)
		
		ammoCount -= 1
		shot_timer.start()
	
func get_ammo_count():
	return ammoCount

func add_ammo_count(count):
	ammoCount += count
