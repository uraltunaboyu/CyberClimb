extends Node

const LevelController = preload("res://scripts/level_controller.gd")
const LOADING_SCREEN_PATH = "res://scenes/loading_screen.tscn"
const HUB_PATH = "res://scenes/levels/hub.tscn"

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
	PAUSED,
	LOADING
}

var current_state: GameStates = GameStates.MAIN_MENU:
	set(new_state):
		if new_state == GameStates.PLAYING || new_state == GameStates.HUB:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
		if new_state == GameStates.LOADING && current_state != GameStates.LOADING:
			get_tree().change_scene_to_file(LOADING_SCREEN_PATH)
		current_state = new_state

var next_scene_path: String

var completed_flags = [ProgressionFlag.NONE]

# TODO figure out inventory
var player_inventory = {}

# TODO figure out upgrades
var player_upgrades = {}

var player_stats = {}
var player_vitals = {}

var level_controller = LevelController.new()

var diff: int = 1
var reward : String
var score_text: String 

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

func load_scene_by_path(target_path: String):
	next_scene_path = target_path
	current_state = GameStates.LOADING

func return_tree():
	return get_tree()

func room_transition(reward_signal: String):
	reward = reward_signal
	diff = level_controller.go_next_room(reward)
	levels_complete += 1

func reset():
	update_score_text()
	PlayerState.reset()
	load_scene_by_path(HUB_PATH)
	level_controller = LevelController.new()

var score_info = []
var enemies_killed = 0
var levels_complete = 0

func update_score_text():
	# todo - add in the time
	var score = 10000.0/float(500) + enemies_killed * 10 + levels_complete * 100
	var cur_run = [500, enemies_killed, levels_complete - 1, score]
	enemies_killed = 0
	levels_complete = 0
	score_info.append(cur_run)
	format_score_info()
	
func format_score_info():
	var text = ""
	for row in score_info:
		for item in row:
			text += "%25s" % str(item)
		text += "\n"
	score_text = text
	
