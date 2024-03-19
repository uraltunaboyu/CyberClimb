extends Area3D

const EnemyAttributes = preload("res://scripts/EnemyAttributes.gd")

@export var min_enemies : int = 0
@export var max_enemies : int
@export var acceptable_enemies : Array[EnemyAttributes.EnemyTag]

func spawn_appropriate_enemy(diff: int):
	var all_enemies = []
	for tag in acceptable_enemies:
		all_enemies.append_array(EnemyAttributes.ENEMY_BY_TAG[tag])
		
	var possible_enemies = EnemyAttributes.intersect(all_enemies, EnemyAttributes.ENEMY_BY_DIFFICULTY[diff])
	# TODO: choose random enemy out of array
	# TODO: spawn enemy in level
	# TODO: maybe return enemy cost?
