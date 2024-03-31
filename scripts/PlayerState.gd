extends Node

enum UpgradeName {
	BASIC_HP,
	BASIC_STAMINA
}

var UPGRADES = {
	UpgradeName.BASIC_HP : func(): hp += 10,
	UpgradeName.BASIC_STAMINA : func(): stamina += 10
}

const string_to_upgrade = {"HP" : UpgradeName.BASIC_HP, "Stamina" : UpgradeName.BASIC_STAMINA}

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
var ammo = 30:
	set(val):
		UIController.set_ammo(val)
		ammo = val

var moveSpeed : float = 5.0
var wallrunCost : float = 0.8

var jumpCooldown = 1.0
var jumpCost: float = 20.0
var doubleJump: float = 33.0
var jumpForce : float = 12

var dashSpeed: float = 20.0
var dashDuration: float = 2.0
var dashCooldownDuration = 3.0
var dashCost: float = 40.0

var staminaRecovery = 20.0
var recoveryDelay = 1.0
var recoveryRate = 0.5

var glideGravity: float = 1.0
var glideSpeedMult: float = 1.5


var _upgrades: Array[UpgradeName] = []

func add_upgrade(name: UpgradeName):
	_upgrades.append(name)
	UPGRADES[name].call()
	
func apply_all_upgrades():
	for upgrade in _upgrades:
		UPGRADES[upgrade].call()

func upgrade_from_string(upgrade: String) -> UpgradeName:
	return string_to_upgrade[upgrade]
