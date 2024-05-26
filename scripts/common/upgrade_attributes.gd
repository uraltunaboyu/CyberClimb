class_name Upgrades extends Node

class Upgrade:
	var upgrade_name: String
	var description: String
	var cost: float
	var callback: Callable
	
	func _init(upgrade_name: String, description: String, cost: float, callback: Callable):
		self.upgrade_name = upgrade_name
		self.description = description
		self.cost = cost
		self.callback = callback

enum UpgradeName {
	BASIC_HP,
	BASIC_STAMINA,
	WALLRUN,
	DOUBLEJUMP
}

static var UPGRADES = {
	UpgradeName.BASIC_HP : Upgrade.new(
		"HP", 
		"Put more blood in your veins so it takes longer to bleed out!", 
		50, 
		func(): PlayerState.hp += 25),
	UpgradeName.BASIC_STAMINA : Upgrade.new(
		"Stamina",
		"Increase the amount of lungs you have by 20%! (Extra ribs may be required)",
		50,
		func(): PlayerState.stamina += 25),
	UpgradeName.WALLRUN : Upgrade.new(
		"Wallrun",
		"Your feet are sticky and you are now able to run on walls!",
		0.3,
		func(): PlayerState.wallrun_enabled = true),
	UpgradeName.DOUBLEJUMP : Upgrade.new(
		"Doublejump",
		"Your farts are now strong enough to propel you midair!",
		0,
		func(): PlayerState.double_jump_enabled = true),
}

const string_to_upgrade = {"HP" : UpgradeName.BASIC_HP, "Stamina" : UpgradeName.BASIC_STAMINA, 
"Wallrun" : UpgradeName.WALLRUN, "Doublejump" : UpgradeName.DOUBLEJUMP}

func upgrade_from_string(upgrade: String) -> UpgradeName:
	return string_to_upgrade[upgrade]
