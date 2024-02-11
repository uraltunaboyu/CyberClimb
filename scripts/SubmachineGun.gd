extends AutoGun

func _ready():
	ammoCount = 50
	bullet_speed = 10
	bullet_damage_min = 4
	bullet_damage_max = 7
	spread_angle = 0.11 # Cone with this angle (radians)
	bullet_life = 1.5
	shots_per_sec = 30
	shot_timer.wait_time = 1/shots_per_sec
	shot_timer.one_shot = true
