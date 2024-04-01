class_name Enemy extends CharacterBody3D

signal dead

# stats
var max_health : int = 100
var cur_health = max_health
var moveSpeed : float

# attacking
var atk_damage : float
var attackRate : float
var attackRange : float

var alive = true
 	
var collider_name = "EnemyCollider"

# components
@onready var dmgScene = preload("res://scenes/DamageVis.tscn")
@onready var player: CharacterBody3D = get_tree().get_first_node_in_group("Player")
@onready var death_ap: AnimationPlayer = $AnimationPlayer

func take_damage(damage:int, pos):
	cur_health -= damage
	# This instantiates the DamageVis scene to display damage dealt to an enemy
	# The % HP loss is calculated (has to be float division) and is sent along
	# The scene is a child of main so it can remain after the enemy dies
	var hp_chunk:float = float(damage)/max_health
	var dmgTxt:Node3D = dmgScene.instantiate()
	get_node("..").add_child(dmgTxt)
	dmgTxt.set_and_animate(damage, hp_chunk, pos)
	
	if cur_health <= 0:
		die()

func die():
	alive = false
	set_physics_process(false)
	find_child(collider_name).queue_free()
	emit_signal("dead")
	if death_ap and death_ap.has_animation("Death"):
		death_ap.play("Death")
	else:
		remove()
	
func remove():
	queue_free()
