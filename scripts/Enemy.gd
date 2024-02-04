extends CharacterBody3D

# stats
var max_health : int = 70
var cur_health = max_health
var moveSpeed : float = 2.0

# attacking
var atk_damage : int = 1
var attackRate : float = 1.0
var attackDist : float = 3.0

var scoreToGive : int = 10

# components
@onready var player : Node = get_node("/root/MainScene/Player")
@onready var timer : Timer = get_node("Timer")
@onready var dmgScene = preload("res://scenes/DamageVis.tscn")

func _ready():
	# setup the timer
	timer.set_wait_time(attackRate)
	timer.start()

func _physics_process(delta):
	# calculate the direction to the player
	var dir = (player.position - position).normalized()
	dir.y = 0
	
	# move the enemy towards the player
	if position.distance_to(player.position) > attackDist:
		set_velocity(dir * moveSpeed)
		move_and_slide()

func take_damage (damage):
	cur_health -= damage
	# 
	var dmgTxt = dmgScene.instantiate()
	get_node("/root/MainScene").add_child(dmgTxt)
	dmgTxt.set_and_animate(damage, global_position)
	
	
	if cur_health <= 0:
		die()

func die ():
	queue_free()

# deals damage to the player
func attack ():
	player.take_damage(atk_damage)

# called every 'attackRate' seconds
func _on_Timer_timeout():
	# if we're at the right distance, attack the player
	if position.distance_to(player.position) <= attackDist:
		attack()
