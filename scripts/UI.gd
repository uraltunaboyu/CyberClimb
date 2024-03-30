extends Control

@onready var healthBar : TextureProgressBar = get_node("HealthBar")
@onready var staminaBar: TextureProgressBar = get_node("StaminaBar")
@onready var ammoText : Label = get_node("AmmoText")

@onready var movementStateText: Label = get_node("DebugInfo/MovementState")

func _ready():
	UIController._initialize()
