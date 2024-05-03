extends Node

const Upgrades = preload("res://scripts/common/upgrade_attributes.gd")
const UpgradeName = Upgrades.UpgradeName
var UPGRADES = Upgrades.UPGRADES

var hp: int = 100:
	set(val):
		UIController.set_cur_hp(hp)
		hp = val
var maxHp: int = 100:
	set(val):
		UIController.set_max_hp(hp)
		maxHp = val
var stamina: float = 100.0:
	set(val):
		UIController.set_cur_stamina(val)
		stamina = val
var maxStamina: float = 100.0:
	set(val):
		UIController.set_max_stamina(val)
		maxStamina = val
var ammo = null:
	set(val):
		UIController.set_ammo(val)
		ammo = val
var credits = 100
var equipped_weapon: WeaponAttributes.Name = WeaponAttributes.Name.NONE

var move_speed : float = 5.0
var wallrun_cost : float = 0.3

var jump_cooldown = 1.0
var jump_cost: float = 20.0
var double_jump_cost: float = 33.0
var jump_force : float = 5

var dash_speed: float = 9.0
var dash_duration: float = 1.5
var dash_cooldown_duration = 1.0
var dash_cost: float = 40.0

var stamina_recovery = 20.0
var recovery_delay = 1.0
var recovery_rate = 0.5

var glide_gravity: float = 4
var glide_speed_mult: float = 1.15


var _upgrades: Array[UpgradeName] = []

func purchase(upgrade_name: UpgradeName):
	var upgrade = UPGRADES[upgrade_name]
	if credits >= upgrade.cost:
		add_upgrade(upgrade_name)

func add_upgrade(name: UpgradeName):
	_upgrades.append(name)
	UPGRADES[name].callback.call()
	
func apply_all_upgrades():
	for upgrade in _upgrades:
		UPGRADES[upgrade].callback.call()

func reset():
	hp = maxHp
	stamina = maxStamina
