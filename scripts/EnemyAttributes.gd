extends Node

enum EnemyTag {
	STATIONARY,
	GROUND,
	FLYING,
	MELEE,
	RANGED
}

enum EnemyName {
	TURRET
}

const ENEMY_SCENE_PATH = {
	EnemyName.TURRET : "<TODO>"
}

const ENEMY_BY_TAG = {
	EnemyTag.STATIONARY : [EnemyName.TURRET],
	EnemyTag.GROUND : [EnemyName.TURRET],
	EnemyTag.FLYING : [],
	EnemyTag.MELEE : [],
	EnemyTag.RANGED : [EnemyName.TURRET]
}

const ENEMY_BY_DIFFICULTY = {
	1 : [EnemyName.TURRET],
	2 : [EnemyName.TURRET],
	3 : [EnemyName.TURRET]
}

static func intersect(a1: Array, a2: Array) -> Array:
	var result: Array = []
	for obj in a1:
		if a2.has(obj):
			result.append(obj)
			
	return result
