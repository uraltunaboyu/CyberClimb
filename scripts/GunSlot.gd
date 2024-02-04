extends Node

@export var target_scene = load("res://scenes/AssultRifle.tscn")
@onready var ui : Node = get_node("/root/MainScene/CanvasLayer/UI")
var equipped_gun

func _ready():
	equipped_gun = target_scene.instantiate()
	add_child(equipped_gun)
	equipped_gun.global_transform = self.global_transform
	
func _process(delta):
	if Input.is_action_pressed("shoot") and equipped_gun is auto_gun:
		attack()
	if Input.is_action_just_pressed("shoot"):
		attack()
		
func attack():
	if equipped_gun:
		equipped_gun.attack()
	ui.update_ammo_text(equipped_gun.get_ammo_count())

func get_ammo_count():
	return equipped_gun.get_ammo_count()
	
func add_ammo(amount):
	equipped_gun.add_ammo(amount)

func set_equipped_gun(new_gun):
	# TODO
	equipped_gun = load(new_gun)
