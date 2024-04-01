class_name Room extends Node

var level_complete: bool = false
var total_enemies: int = 0

var rewards = {'power' : 0, 'money' : 0}
const chosen_multiplier = 1.5
signal completed

func _ready():
	_set_rewards(GameState.reward, GameState.diff)
	_spawn_enemies(GameState.diff)
	level_complete = total_enemies == 0

func _spawn_enemies(diff: int)->void:
	# Iterate through spawn areas
	# For an area:
	## Calculate number of enemies based on round(average(min_enemies, max_enemies) * difficulty)
	## 
	for spawn_point in get_tree().get_nodes_in_group("spawn_area"):
		if spawn_point.max_enemies == 0: continue
		var enemy_count = (randi() % spawn_point.max_enemies) + spawn_point.min_enemies
		Log.Info("Trying to spawn %s enemies" % enemy_count)
		for i in range(enemy_count):
			var enemy = spawn_point.spawn_appropriate_enemy(diff)
			if enemy:
				total_enemies += 1
				enemy.dead.connect(_on_enemy_dead)
				

func _set_rewards(reward, diff) -> void:
	if reward == 'money':
		rewards['money'] = diff*chosen_multiplier
	else:
		rewards['power'] = diff*chosen_multiplier

func _on_enemy_dead():
	total_enemies -= 1
	if total_enemies == 0:
		level_complete = true

func _next_room(reward):
	if level_complete:
		PlayerState.credits += 20
		GameState.room_transition(reward)
