extends CharacterBody3D

# stats
var health : int = 5
var moveSpeed : float = 2.0

# attacking
var damage : int = 1
var attackRate : float = 1.0
var attackDist : float = 2.0

var scoreToGive : int = 10

# components
@onready var player : Node = get_node("/root/MainScene/Player")
@onready var timer : Timer = get_node("Timer")
var upgrades;

func _ready():
	# setup the timer
	timer.set_wait_time(attackRate)
	timer.start()
	self.upgrades = player.upgrades

func _physics_process(delta):
	# calculate the direction to the player
	var dir = (player.position - position).normalized()
	dir.y = 0
	
	# move the enemy towards the player
	if position.distance_to(player.position) > attackDist:
		set_velocity(dir * moveSpeed)
		move_and_slide()

func take_damage (damage):
	health -= damage
	
	if health <= 0:
		die()
	
	if self.upgrades.get_upgrade("cheat_death"):
		player.add_health(damage)

func die ():
	queue_free()

# deals damage to the player
func attack ():
	player.take_damage(damage)

# called every 'attackRate' seconds
func _on_Timer_timeout():
	# if we're at the right distance, attack the player
	if position.distance_to(player.position) <= attackDist:
		attack()
