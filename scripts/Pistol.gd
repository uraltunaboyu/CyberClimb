class_name SemiAutoGun extends Gun

func _ready():
	ammoCount = 100
	bullet_speed = 15
	bullet_damage_min = 8
	bullet_damage_max = 12
	spread_angle = 0.05 # Cone with this angle (radians)
	bullet_life = 1.3
	shots_per_sec = 3
	shot_timer.wait_time = 1/shots_per_sec
	shot_timer.one_shot = true
	
func attack():
	if ammoCount != 0 and shot_timer.is_stopped():
		make_bullet()
		$AudioStreamPlayer.play()
		
		ammoCount -= 1
		shot_timer.start()
