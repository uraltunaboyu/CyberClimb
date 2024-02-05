extends Node

@onready var ui : Node = get_node("/root/MainScene/CanvasLayer/UI")
var equipped_gun

func _ready():
	if equipped_gun:
		add_child(equipped_gun)
		equipped_gun.global_transform = self.global_transform
	
func _process(_delta):
	if Input.is_action_pressed("shoot") and equipped_gun is AutoGun:
		attack()
	elif Input.is_action_just_pressed("shoot"):
		attack()
		
func attack():
	if equipped_gun:
		equipped_gun.attack()
		ui.update_ammo_text(equipped_gun.get_ammo_count())

func get_ammo_count():
	if equipped_gun:
		return equipped_gun.get_ammo_count()
	
func add_ammo(amount):
	if equipped_gun:
		equipped_gun.add_ammo(amount)

func set_equipped_gun(new_gun):
	# TODO
	var replacing_gun = load(new_gun)
	if equipped_gun:
		get_child(0).queue_free()
	equipped_gun = replacing_gun.instantiate()
	add_child(equipped_gun)
	equipped_gun.global_transform = self.global_transform
	ui.update_ammo_text(equipped_gun.get_ammo_count())
	
