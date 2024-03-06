extends SemiAutoGun

var pellet_count = 30

func _ready():
	ammoCount = 15
	bullet_speed = 18
	bullet_damage_min = 1
	bullet_damage_max = 5
	spread_angle = 0.25 # Cone with this angle (radians)
	bullet_life = 1
	shots_per_sec = 1.2
	shot_timer.wait_time = 1/shots_per_sec
	shot_timer.one_shot = true
	
func attack():
	if ammoCount != 0 and shot_timer.is_stopped():
		for i in range(pellet_count):
			make_bullet()
		
		ammoCount -= 1
		shot_timer.start()
