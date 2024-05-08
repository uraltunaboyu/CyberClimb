class_name Bullet extends Area3D

var speed : float = 30.0
var damage : int = 1
var shooter

func initialize(bullet_speed, bullet_damage, lifetime, bullet_shooter):
	speed = bullet_speed
	damage = bullet_damage
	shooter = bullet_shooter
	var life : Timer = Timer.new()
	add_child(life)
	life.wait_time = lifetime
	life.autostart = true
	life.timeout.connect(destroy)

	
# called every frame
func _process(delta):
	# move the bullet forwards
	position += global_transform.basis.z * speed * delta

# destroys the bullet
func destroy ():
	queue_free()

# called when we enter the collider of another body
func _on_Bullet_body_entered(body):
	destroy()
	# does this body have a 'take_damage' function?
	# if so, deal damage and destroy the bullet
	if body.has_method("take_damage"):
		if body.is_in_group("Enemy"):
			body.take_damage(damage, position)
		else:
			body.take_damage(damage, shooter)
