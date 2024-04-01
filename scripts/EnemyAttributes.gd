extends Node

enum EnemyTag {
	STATIONARY,
	GROUND,
	FLYING,
	MELEE,
	RANGED
}

enum EnemyName {
	TURRET,
	DRONE
}

const ENEMY_SCENE_PATH = {
	EnemyName.TURRET : "res://scenes/enemies/Turret.tscn",
	EnemyName.DRONE : "res://scenes/enemies/Drone.tscn"
}

const ENEMY_BY_TAG = {
	EnemyTag.STATIONARY : [EnemyName.TURRET],
	EnemyTag.GROUND : [EnemyName.TURRET],
	EnemyTag.FLYING : [EnemyName.DRONE],
	EnemyTag.MELEE : [],
	EnemyTag.RANGED : [EnemyName.TURRET, EnemyName.DRONE]
}

const ENEMY_BY_DIFFICULTY = {
	1 : [EnemyName.TURRET, EnemyName.DRONE],
	2 : [EnemyName.TURRET, EnemyName.DRONE],
	3 : [EnemyName.TURRET, EnemyName.DRONE],
	4 : [EnemyName.TURRET, EnemyName.DRONE],
	5 : [EnemyName.TURRET, EnemyName.DRONE],
	6 : [EnemyName.TURRET, EnemyName.DRONE],
}

static func intersect(a1, a2):
	var result = []
	for obj in a1:
		if a2.has(obj):
			result.append(obj)
			
	return result
	
static func union(a1, a2):
	var result = []
	for obj in a1:
		if !a2.has(obj):
			result.append(obj)
			
	for obj in a2:
		result.append(obj)
		
	return result
