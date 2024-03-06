extends Node3D

@onready var muzzle : Node3D = get_node("Muzzle")
@onready var bulletScene = preload("res://scenes/Bullet.tscn")
var ammoCount = 100

func _ready():
	print("Sun's out guns out")
	
func attack():
	if ammoCount == 0: return
	
	var bullet = bulletScene.instantiate()
	get_node("/root/MainScene").add_child(bullet)
	
	bullet.global_transform = muzzle.global_transform
	
	ammoCount -= 1
	
func get_ammo_count():
	return ammoCount

func add_ammo_count(count):
	ammoCount += count
