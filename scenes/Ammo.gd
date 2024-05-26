class_name Ammo extends Area3D


func _on_body_entered(body):
	print("here")
	queue_free()
	if body.has_method("add_ammo_from_pickup"):
		body.add_ammo_from_pickup()
		
