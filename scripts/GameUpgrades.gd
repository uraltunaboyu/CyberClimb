extends Node

class_name GameUpgrades

const Upgrade = preload("GameUpgrade.gd")

var upgrade_list

func _init(): # initalizes the upgrades
	self.upgrade_list = {}
	self.upgrade_list["max_hp"] = Upgrade.new(0)
	self.upgrade_list["jump_force"] = Upgrade.new(0)
	self.upgrade_list["move_speed"] = Upgrade.new(0)
	self.upgrade_list["start_ammo"] = Upgrade.new(0)
	self.upgrade_list["magic_reload"] = Upgrade.new(false)
	self.upgrade_list["cheat_death"] = Upgrade.new(false)
	self.upgrade_list["lifesteal"] = Upgrade.new(false)

func get_upgrade(name): # returns upgrade
	return self.upgrade_list[name].upgrade_value

func set_value(name, value): # returns upgrade
	self.upgrade_list[name].set_value(value)
