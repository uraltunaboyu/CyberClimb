extends Area3D

const EnemyAttributes = preload("res://scripts/EnemyAttributes.gd")

@export var min_enemies : int = 0
@export var max_enemies : int
@export var acceptable_enemies : Array[EnemyAttributes.EnemyTag]

@onready var all_enemies = []
const MAX_ATTEMPTS = 100

func _ready():
	for tag in acceptable_enemies:
		all_enemies = EnemyAttributes.union(all_enemies, EnemyAttributes.ENEMY_BY_TAG[tag])
	
func get_spawn_bounds():
	var collision_shape = $CollisionShape3D
	var shape = collision_shape.shape
	
	if shape is BoxShape3D:
		var extents = shape.extents
		var spawn_area_min = global_transform.origin - extents
		var spawn_area_max = global_transform.origin + extents
		return [spawn_area_min, spawn_area_max]
	Log.Error("Invalid spawn area shape")
	return [Vector3.ZERO, Vector3.ZERO]
	
func get_random_point(area_min: Vector3, area_max: Vector3) -> Vector3:
	return Vector3(randf_range(area_min.x, area_max.x),
				   0,
				   randf_range(area_min.z, area_max.z))

func spawn_appropriate_enemy(diff: int):
	var enemy_pool = EnemyAttributes.intersect(all_enemies, EnemyAttributes.ENEMY_BY_DIFFICULTY[diff])
		
	var chosen_enemy_name: EnemyAttributes.EnemyName = enemy_pool[randi() % len(enemy_pool)]
	var chosen_enemy_path: String = EnemyAttributes.ENEMY_SCENE_PATH[chosen_enemy_name]
	
	var chosen_enemy_scene = load(chosen_enemy_path)
	var chosen_enemy_instance = chosen_enemy_scene.instantiate()
	
	var enemy_radius = _calculate_radius(chosen_enemy_instance.get_node("EnemyCollider"))
	# TODO adjust enemy stats
	var overlapping = false
	var attempt = 0
	
	while attempt < MAX_ATTEMPTS and not overlapping:
		var bounds = get_spawn_bounds()
		var spawn_point = get_random_point(bounds[0], bounds[1])
		spawn_point.y = enemy_radius
		overlapping = _check_overlap(spawn_point, enemy_radius)
		if overlapping: 
			attempt += 1
			continue
		get_node("../EnemyHolder").add_child(chosen_enemy_instance)
		chosen_enemy_instance.global_transform.origin = spawn_point
		return
		
	Log.Warn("Max attempts exceeded while trying to spawn enemy")
		
func _check_overlap(pos: Vector3, radius: float) -> bool:
	var space_state = get_world_3d().direct_space_state
	var query_shape = SphereShape3D.new()
	query_shape.radius = radius
	
	var shape_query = PhysicsShapeQueryParameters3D.new()
	shape_query.set_shape(query_shape)
	shape_query.transform = Transform3D.IDENTITY.translated(pos)
	
	var result = space_state.intersect_shape(shape_query)
	return result.size() > 0
	
func _calculate_radius(collider: Node) -> float:
	if collider is CollisionShape3D:
		var shape = collider.shape
		if shape is BoxShape3D:
			var extents = shape.extents
			var max_extent = max(extents.x, extents.y, extents.z)
			return max_extent / 2.0
		elif shape is SphereShape3D:
			return shape.radius
		elif shape is CapsuleShape3D:
			return max(shape.radius, shape.height / 2.0)
		else:
			Log.Warn("Unknown shape type %s" % typeof(shape))
			return 1.0
	elif collider is CollisionPolygon3D:
		var points = collider.polygon
		var aabb = AABB()
		for point in points:
			aabb.expand(Vector3(point.x, point.y, 0))
		
		return aabb.get_longest_axis_size() / 2.0
		
	Log.Warn("Unknown collider type %s" % typeof(collider))
	return 1.0
