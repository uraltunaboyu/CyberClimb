extends Node

@export var target_scene = load("res://scenes/Shotgun.tscn")
var equipped_gun

func _ready():
	equipped_gun = target_scene.instantiate()
	add_child(equipped_gun)
	equipped_gun.global_transform = self.global_transform

func attack():
	equipped_gun.attack()

func get_ammo_count():
	return equipped_gun.get_ammo_count()
	
func add_ammo(amount):
	equipped_gun.add_ammo(amount)

func set_equipped_gun(new_gun):
	# TODO
	equipped_gun = load(new_gun)
