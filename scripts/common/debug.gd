extends Node

var _cubes: Dictionary = {
	
}

const DEBUG_MODE = true

func debug_cube(id: String, pos: Vector3, ref: Node, color = null):
	if not DEBUG_MODE: return
	if _cubes.has(id):
		_cubes.get(id).free()
	_cubes[id] = MeshInstance3D.new()
	var cube_mesh = BoxMesh.new()
	cube_mesh.size = Vector3(1, 1, 1)
	if color:
		var material = StandardMaterial3D.new()
		material.color = color
		_cubes[id].material = material
	_cubes[id].mesh = cube_mesh
	Log.Debug("Creating debug cube %s at %s" % [id, pos])
	ref.get_tree().root.add_child(_cubes[id])
	_cubes[id].global_position = pos
