class_name Room extends Node

var enemies = {}
var info # holds the values for above vars

var rewards = {'power' : 0, 'money' : 0}
const chosen_multiplier = 1.5
var player = preload("res://scenes/Player.tscn")

func _ready():
	generate(GameState.reward, GameState.diff)

func check_clear() -> bool:
	return self.find_children("EnemyHolder").is_empty()
	
func load_info(json_content:String)->void:
	info = JSON.parse_string(json_content)
	enemies = info[enemies]
	
func spawn_enemies(diff: int)->void:
	# Iterate through spawn areas
	# For an area:
	## Calculate number of enemies based on round(average(min_enemies, max_enemies) * difficulty)
	## 
	for spawn_point in get_tree().get_nodes_in_group("spawn_area"):
		if spawn_point.max_enemies == 0: continue
		var enemy_count = (randi() % spawn_point.max_enemies) + spawn_point.min_enemies
		Log.Info("Trying to spawn %s enemies" % enemy_count)
		for i in range(enemy_count):
			spawn_point.spawn_appropriate_enemy(diff)

func set_rewards(reward, diff)->void:
	if reward == 'money':
		rewards['money'] = diff*chosen_multiplier
	else:
		rewards['power'] = diff*chosen_multiplier
	
func load_player()->void:
	player.instantiate()
	#get_tree().add_child(player)
	
func generate(reward:String, diff:int)->int:
	#load_player()
	set_rewards(reward, diff)
	spawn_enemies(diff)
	# stop execution let the game play
	return 1
