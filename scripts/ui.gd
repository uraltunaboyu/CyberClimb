extends Control

@onready var healthBar : TextureProgressBar = $HealthBar
@onready var staminaBar: TextureProgressBar = $StaminaBar
@onready var ammoText : Label = $AmmoText
@onready var crosshair : TextureRect = $Crosshair
@onready var promptText : Label = $Prompt
@onready var bloodOverlay : TextureRect = $BloodOverlay
@onready var damageIndicator : Node2D = $DamageIndicator
@onready var indicatorTimer : Timer = $IndicatorTimer

@onready var movementStateText: Label = $DebugInfo/MovementState


func _on_indicator_timer_timeout():
	damageIndicator.hide()
