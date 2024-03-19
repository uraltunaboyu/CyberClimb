class_name Room extends Node

var enemies
var info # holds the values for above vars

var rewards = {'power' : 0, 'money' : 0}
const chosen_multiplier = 1.5
var player = preload("res://scenes/Player.tscn")
signal completed

func _ready():
	generate(GameState.reward, GameState.diff)

func load_info(json_content:String)->void:
	info = JSON.parse_string(json_content)
	enemies = info[enemies]

func set_enemies(diff)->void:
	for enemy in enemies:
		enemies[enemy] = round(enemies[enemy] * diff)
	# multiply each enemies weight by difficulty and round.
	
func spawn_enemies()->void:
	# Iterate through spawn areas
	# For an area:
	## Calculate number of enemies based on round(average(min_enemies, max_enemies) * difficulty)
	## 
	for enemy in enemies:
		for n in enemies[enemy]:
			enemy.instantiate()
			get_node('/root/MainScene').add_child(enemy) # to be updated
			
func position_enemy(enemy:Object):
	print('position')
	

func set_rewards(reward, diff)->void:
	if reward == 'money':
		rewards['money'] = diff*chosen_multiplier
	else:
		rewards['power'] = diff*chosen_multiplier
	
func load_player()->void:
	player.instantiate()
	get_tree().add_child(player)
	
func generate(reward:String, diff:int)->int:
	load_player()
	set_rewards(reward, diff)
	set_enemies(diff)
	#spawn_enemies()
	# stop execution let the game play
	return 1

func change_scene(_gugu: String):
	get_tree().change_scene_to_file("res://Rooms/TestLevel.tscn")
