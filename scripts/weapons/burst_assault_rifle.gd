class_name BurstGun extends Gun

@onready var burst_timer : Timer = $BurstTimer

var burst_shots = 3
var burst_delay = 0.05

func _ready():
	ammoCount = 200
	bullet_speed = 20
	bullet_damage_min = 8
	bullet_damage_max = 14
	spread_angle = 0.06
	bullet_life = 2
	shots_per_sec = 1.33
	shot_timer.wait_time = 1/shots_per_sec
	shot_timer.one_shot = true
	burst_timer.wait_time = burst_delay
	burst_timer.one_shot = true
	
func multiple_attacks():
	for i in burst_shots:
		if ammoCount != 0:
			burst_timer.start()
			await burst_timer.timeout
			
			make_bullet()
			$ShotPlayer.play()
			ammoCount -= 1

func attack():
	if ammoCount!= 0 and shot_timer.is_stopped():
		multiple_attacks()
		shot_timer.start()
