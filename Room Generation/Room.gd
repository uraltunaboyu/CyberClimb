class_name Room extends Node

var enemies
var info # holds the values for above vars

var rewards = {'power' : 0, 'money' : 0}
const chosen_multiplier = 1.5
var player = preload("res://scenes/Player.tscn")
var difficulty : int = 1 : set = set_difficulty
signal completed


func load_info(json_content:String)->void:
	info = JSON.parse_string(json_content)
	enemies = info[enemies]

func set_enemies()->void:
	for enemy in enemies:
		enemies[enemy] = round(enemies[enemy] * difficulty)
	# multiply each enemies weight by difficulty and round.
	
func spawn_enemies()->void:
	for enemy in enemies:
		for n in enemies[enemy]:
			enemy.instantiate()
			get_node('/root/MainScene').add_child(enemy) # to be updated
			
func position_enemy(enemy:Object):
	print('position')
	

func set_rewards(reward)->void:
	if reward == 'money':
		rewards['money'] = difficulty*chosen_multiplier
	else:
		rewards['power'] = difficulty*chosen_multiplier
	
func load_player()->void:	
	player.instantiate()
	get_tree().add_child(player)
	
func set_difficulty(val:int)->void:
	difficulty = val
	# will determine num_enemies and rewards
	
func generate(reward:String, diff:int)->int:
	load_player()
	set_difficulty(diff)
	set_rewards(reward)
	#set_enemies()
	#spawn_enemies()
	# stop execution let the game play
	return 1

func change_scene(_gugu: String):
	get_tree().change_scene_to_file("res://Rooms/TestLevel.tscn")
