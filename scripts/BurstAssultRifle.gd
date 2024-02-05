class_name BurstGun extends Node3D

@onready var muzzle : Node3D = $Muzzle
@onready var bulletScene = preload("res://scenes/Bullet.tscn")
@onready var shot_timer : Timer = $Timer
@onready var burst_timer : Timer = $BurstTimer

var ammoCount = 50
var bullet_speed = 18
var bullet_damage_min = 15
var bullet_damage_max = 20
var spread_angle:float = 0.03 # Cone with this angle (radians)
var bullet_life = 1
var rpm:float = 80
var burst_shots = 3
var burst_delay = 0.05
var burst_left = burst_shots

func _ready():
	shot_timer.wait_time = 60/rpm
	shot_timer.one_shot = true
	burst_timer.wait_time = burst_delay
	burst_timer.one_shot = true
	return
	
func multiple_attacks():
	for i in burst_shots:
		if ammoCount != 0:
			burst_timer.start()
			await burst_timer.timeout
			var bullet = bulletScene.instantiate()
			bullet.initialize(bullet_speed, randi_range(bullet_damage_min, bullet_damage_max), bullet_life)
			
			get_node("/root/MainScene").add_child(bullet)
			bullet.global_transform = muzzle.global_transform
			
			var angle_x = randfn(0, spread_angle/1.5)
			var angle_y = randfn(0, spread_angle/1.5)
			
			bullet.rotate_object_local(Vector3(1,0,0), angle_x)
			bullet.rotate_object_local(Vector3(0,1,0), angle_y)
			
			ammoCount -= 1

func attack():
	if ammoCount!= 0 and shot_timer.is_stopped():
		multiple_attacks()
		shot_timer.start()
		

func get_ammo_count():
	return ammoCount

func add_ammo_count(count):
	ammoCount += count
