extends Node

const LevelController = preload("res://scripts/LevelController.gd")

enum ProgressionFlag {
	NONE,
	TUTORIAL,
	FIRST_BOSS
}

var completed_flags = [ProgressionFlag.NONE]

# TODO figure out inventory
var player_inventory = {}

# TODO figure out upgrades
var player_upgrades = {}

var player_stats = {}
var player_vitals = {}

var level_controller = LevelController.new()

func is_flag_complete(flag: ProgressionFlag) -> bool:
	return completed_flags.has(flag)
	
func complete_flag(flag: ProgressionFlag):
	completed_flags.append(flag)
	
func latest_flag() -> ProgressionFlag:
	# this is not great
	return completed_flags[completed_flags.size() - 1]
