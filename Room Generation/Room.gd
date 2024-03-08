class_name Room extends Node

var enemy1 = preload("res://scenes/Enemy.tscn")
var reward_category = 'money'
var rewards = {'power' : 0, 'money' : 0}
var chosen_multiplier = 1.5
var not_chosen_multiplier = 0.75
var player = preload("res://scenes/Player.tscn")
var enemies : Dictionary = {enemy1 : 0, 'enemy2' : 0, 'enemy3' : 0, 'enemy4' : 0}
var difficulty : int = 1 : set = set_difficulty

func set_enemies()->void:
	var curr_difficulty = difficulty
	if difficulty >= 4:
		enemies['enemy4'] = difficulty/4
		curr_difficulty = curr_difficulty - 4*enemies['enemy4']
	if curr_difficulty >= 3:
		enemies['enemy3'] = curr_difficulty/3
		curr_difficulty = curr_difficulty - 3*enemies['enemy3']
	if curr_difficulty >= 3:
		enemies['enemy2'] = curr_difficulty/2
		curr_difficulty = curr_difficulty - 2*enemies['enemy2']
	if curr_difficulty >= 1:
		enemies['enemy1'] = curr_difficulty
		curr_difficulty = 0
	
func spawn_enemies()->void:
	for enemy in enemies:
		for n in enemies[enemy]:
			print('spawning' + enemy)
			enemy.instantiate()

func set_rewards()->void:
	if reward_category == 'money':
		rewards['money'] = difficulty*chosen_multiplier
		rewards['power'] = difficulty*not_chosen_multiplier
	else:
		rewards['money'] = difficulty*not_chosen_multiplier
		rewards['power'] = difficulty*chosen_multiplier
	
func load_player()->void:	
	player.instantiate()
	
func set_difficulty(val:int)->void:
	difficulty = val
	# will determine num_enemies and rewards

func generate():
	load_player()
	set_difficulty(10)
	set_rewards()
	set_enemies()
	spawn_enemies()
	print("test generation")
	# start with sequence generation
