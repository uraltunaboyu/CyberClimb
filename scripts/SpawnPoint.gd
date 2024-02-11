extends Node3D

func _on_button_interacted(target_scene):
	
	var enemyScene = load(target_scene)
	var enemy = enemyScene.instantiate()
	get_parent().add_child(enemy)
