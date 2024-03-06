extends Control

@onready var healthBar : TextureProgressBar = get_node("HealthBar")
@onready var ammoText : Label = get_node("AmmoText")

@export var debugMode: bool = false
@onready var movementStateText: Label = get_node("DebugInfo/MovementState")

func _ready():
	# TODO disable debug info
	pass

func update_health_bar(curHp, maxHp):
	healthBar.max_value = maxHp
	healthBar.value = curHp
	
func update_ammo_text(ammo):
	ammoText.text = "Ammo: " + str(ammo)
	
func update_movement_state(state):
	movementStateText.text = str(state)
