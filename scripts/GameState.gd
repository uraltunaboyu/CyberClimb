extends Node

const LevelController = preload("res://scripts/LevelController.gd")

enum ProgressionFlag {
	NONE,
	TUTORIAL,
	FIRST_BOSS
}

enum GameStates {
	MAIN_MENU,
	HUB,
	PLAYING,
	SHOP,
	PAUSED
}

var current_state: GameStates = GameStates.MAIN_MENU:
	set(new_state):
		if (new_state == GameStates.PLAYING || new_state == GameStates.HUB):
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		current_state = new_state

var completed_flags = [ProgressionFlag.NONE]

# TODO figure out inventory
var player_inventory = {}

# TODO figure out upgrades
var player_upgrades = {}

var player_stats = {}
var player_vitals = {}

var level_controller = LevelController.new()

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(_delta):
	if Input.is_action_just_pressed("exit"):
		if current_state == GameStates.MAIN_MENU:
			get_tree().quit()
		elif current_state != GameStates.PAUSED:
			current_state = GameStates.PAUSED
			get_tree().paused = true
		else:
			current_state = GameStates.PLAYING;
			get_tree().paused = false

func set_state_playing():
	current_state = GameStates.PLAYING
	

func is_flag_complete(flag: ProgressionFlag) -> bool:
	return completed_flags.has(flag)
	
func complete_flag(flag: ProgressionFlag):
	completed_flags.append(flag)
	
func latest_flag() -> ProgressionFlag:
	# this is not great
	return completed_flags[completed_flags.size() - 1]
