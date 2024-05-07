extends Node

enum UpgradeName {
	BASIC_HP,
	BASIC_STAMINA
}

var UPGRADES = {
	UpgradeName.BASIC_HP : func(): hp += 25,
	UpgradeName.BASIC_STAMINA : func(): stamina += 25
}

const COST = {
	UpgradeName.BASIC_HP : 50,
	UpgradeName.BASIC_STAMINA : 50
}

const string_to_upgrade = {"HP" : UpgradeName.BASIC_HP, "Stamina" : UpgradeName.BASIC_STAMINA}

var hp: int = 100:
	set(val):
		UIController.set_cur_hp(val)
		hp = val
var maxHp: int = 100:
	set(val):
		UIController.set_max_hp(val)
		var increase = val - maxHp
		if increase > 0:
			hp += increase
			
		maxHp = val
var stamina: float = 100.0:
	set(val):
		UIController.set_cur_stamina(val)
		stamina = val
var maxStamina: float = 100.0:
	set(val):
		UIController.set_max_stamina(val)
		stamina += val - maxStamina
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

func add_upgrade(name: UpgradeName):
	_upgrades.append(name)
	UPGRADES[name].call()
	
func apply_all_upgrades():
	for upgrade in _upgrades:
		UPGRADES[upgrade].call()

func upgrade_from_string(upgrade: String) -> UpgradeName:
	return string_to_upgrade[upgrade]

func reset():
	hp = maxHp
	stamina = maxStamina
