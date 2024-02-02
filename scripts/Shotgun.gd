extends Node3D

@onready var muzzle : Node3D = get_node("Muzzle")
@onready var bulletScene = preload("res://scenes/Bullet.tscn")

var ammoCount = 100
var bullet_speed = 5
var bullet_damage = 1
var pellet_count = 10
var spread_angle:float = 0.25 # Cone with this angle (radians)
var bullet_life = 1

func _ready():
	return
	
func attack():
	if ammoCount == 0: return
	
	for i in range(pellet_count):
		var bullet = bulletScene.instantiate()
		bullet.initialize(bullet_speed, bullet_damage, bullet_life)
		
		get_node("/root/MainScene").add_child(bullet)
		bullet.global_transform = muzzle.global_transform
		
		var angle_x = randf_range(spread_angle, -spread_angle)
		var angle_y = randf_range(spread_angle, -spread_angle)
		
		bullet.rotate_object_local(Vector3(1,0,0), angle_x)
		bullet.rotate_object_local(Vector3(0,1,0), angle_y)
		
		
	
	ammoCount -= 1
	
func get_ammo_count():
	return ammoCount

func add_ammo_count(count):
	ammoCount += count
