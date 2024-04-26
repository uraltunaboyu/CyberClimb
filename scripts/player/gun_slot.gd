extends Node

var equipped_gun = null
var default_position : Vector3

func _ready():
	if equipped_gun:
		add_child(equipped_gun)
		equipped_gun.global_transform = self.global_transform
		default_position = equipped_gun.position
	
func _process(_delta):
	if Input.is_action_pressed("shoot") and (equipped_gun is AutoGun or equipped_gun is BurstGun):
		attack()
	elif Input.is_action_just_pressed("shoot"):
		attack()
		
func attack():
	if equipped_gun:
		equipped_gun.attack()
		equipped_gun.apply_recoil()
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

func set_equipped_gun(new_gun, set_ammo = true):
	# TODO
	var replacing_gun = load(new_gun)
	if equipped_gun:
		get_child(0).queue_free()
	equipped_gun = replacing_gun.instantiate()
	add_child(equipped_gun)
	equipped_gun.global_position = self.global_position
	if set_ammo:
		PlayerState.ammo = equipped_gun.get_ammo_count()
	
func remove_weapon():
	if equipped_gun:
		get_child(0).queue_free()
	equipped_gun = null
	
func load_state():
	var weapon = PlayerState.equipped_weapon
	if weapon != WeaponAttributes.Name.NONE:
		set_equipped_gun(WeaponAttributes.SCENE[weapon], false)


func weapon_bob(velocity: float, delta):
	if equipped_gun:
		if velocity > 0:
			var bob_amount : float = 0.015
			var bob_freq : float = 0.015
			equipped_gun.position.y = lerp(equipped_gun.position.y, default_position.y + sin(Time.get_ticks_msec() * bob_freq) * bob_amount, 10 * delta)
			equipped_gun.position.x = lerp(equipped_gun.position.x, default_position.x + sin(Time.get_ticks_msec() * bob_freq * 0.5) * bob_amount, 10 * delta)
		else:	
			equipped_gun.position.y = lerp(equipped_gun.position.y, default_position.y, 10 * delta)
			equipped_gun.position.x = lerp(equipped_gun.position.x, default_position.x, 10 * delta)
