class_name PathfindingEnemy extends Enemy

@onready var _navigator: NavigationAgent3D = $NavigationAgent3D
var movement_speed: float = 2.0
var rotation_speed: float = 1.0

func set_navigation_target(point: Vector3):
	_navigator.set_target_position(point)
	
func get_navigation_target():
	return _navigator.target_position
	
func navigate_to_target(delta: float):
	if _navigator.is_navigation_finished():
		return
		
	var current_pos: Vector3 = global_position
	var next_path_pos: Vector3 = _navigator.get_next_path_position()
	
	var new_angle = global_transform.looking_at(next_path_pos)
	global_transform = global_transform.interpolate_with(new_angle, rotation_speed * delta)
	
	velocity = current_pos.direction_to(next_path_pos) * movement_speed
	move_and_slide()

func set_desired_target_distance(dist: float):
	_navigator.target_desired_distance = dist
