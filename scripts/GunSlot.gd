extends Node

@onready var ui : Node = get_node("../../../CanvasLayer/UI")
var equipped_gun = null

func _ready():
	if equipped_gun:
		add_child(equipped_gun)
		equipped_gun.global_transform = self.global_transform
	
func _process(_delta):
	if Input.is_action_pressed("shoot") and (equipped_gun is AutoGun or equipped_gun is BurstGun):
		attack()
	elif Input.is_action_just_pressed("shoot"):
		attack()
		
func attack():
	if equipped_gun:
		equipped_gun.attack()
		PlayerState.ammo = equipped_gun.get_ammo_count()

func get_ammo_count():
	# Known bug, for burst weapons, only gets ammo when click is held.
	# The logic is easy to understand why, but I can't think of a solution
	# when the UI call is within this script. Could be solved by moving it
	# to the weapon itself.
	if equipped_gun:
		return equipped_gun.get_ammo_count()
	
func add_ammo(amount):
	if equipped_gun:
		equipped_gun.add_ammo_count(amount)
		PlayerState.ammo = equipped_gun.get_ammo_count()

func set_equipped_gun(new_gun):
	# TODO
	var replacing_gun = load(new_gun)
	if equipped_gun:
		get_child(0).queue_free()
	equipped_gun = replacing_gun.instantiate()
	add_child(equipped_gun)
	equipped_gun.global_transform = self.global_transform
	PlayerState.ammo = equipped_gun.get_ammo_count()
	
func remove_weapon():
	if equipped_gun:
		get_child(0).queue_free()
		ui.update_ammo_text(null)
	equipped_gun = null
	
