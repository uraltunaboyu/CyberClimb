extends SemiAutoGun

@onready var ap : AnimationPlayer = $shotgun/AnimationPlayer

var pellet_count = 20

func _ready():
	muzzle = $shotgun/Muzzle
	ammoCount = 100
	bullet_speed = 18
	bullet_damage_min = 1
	bullet_damage_max = 15
	spread_angle = 0.18 # Cone with this angle (radians)
	bullet_life = 1
	shots_per_sec = 1.2
	shot_timer.wait_time = 1/shots_per_sec
	shot_timer.one_shot = true
	
func attack():
	if ammoCount != 0 and shot_timer.is_stopped():
		for i in range(pellet_count):
			make_bullet()
		$ShootAudio.play()
		ap.play("shotgun_pump")
		
		ammoCount -= 1
		shot_timer.start()
