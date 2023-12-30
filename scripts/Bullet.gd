extends Area3D

var speed : float = 30.0
var damage : int = 1
var lifetime : float = 1.0

# called every frame
func _process(delta):
	# move the bullet forwards
	position += global_transform.basis.z * speed * delta
	lifetime -= delta
	if lifetime <= 0:
		print("destroying bullet now")
		destroy()

# destroys the bullet
func destroy ():
	queue_free()

# called when we enter the collider of another body
func _on_Bullet_body_entered(body):
	# does this body have a 'take_damage' function?
	# if so, deal damage and destroy the bullet
	if body.has_method("take_damage"):
		body.take_damage(damage)
		destroy()
