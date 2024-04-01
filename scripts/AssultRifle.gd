class_name AutoGun extends Gun

func _ready():
	ammoCount = 40
	bullet_speed = 15
	bullet_damage_min = 11
	bullet_damage_max = 15
	spread_angle = 0.06
	bullet_life = 2
	shots_per_sec = 20
	shot_timer.wait_time = 1/shots_per_sec
	shot_timer.one_shot = true
	
func attack():
	if ammoCount != 0 and shot_timer.is_stopped():
		make_bullet()
		$ShotAudio.play()
		ammoCount -= 1
		shot_timer.start()
