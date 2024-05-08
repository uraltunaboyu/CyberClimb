extends Node

const SHOTGUN_PRICE = 100
const SHOTGUN_SCENE = "res://scenes/Shotgun.tscn"

@onready var _credits_text = $CanvasLayer/HubUI/CreditsText
@onready var _player = $Player
@onready var _score_text = $ScoreBillboard/ScoreText
@onready var credits: int:
	get:
		return PlayerState.credits
	set(_credits):
		_credits_text.text = "Credits: " + str(_credits)
		PlayerState.credits = _credits

func _ready():
	credits = PlayerState.credits
	_score_text.text = GameState.score_text
	add_collected_credits()
	AudioController.play_hub_music()
	UIController.disable_crosshair()

func purchase_weapon(name):
	var weapon = WeaponAttributes.BY_NAME[name]
	Log.Info("Attempting to purchase %s" % name)
	if credits >= WeaponAttributes.COST[weapon]:
		get_tree().create_tween().tween_method(set_credits_value, credits, credits - WeaponAttributes.COST[weapon], 1)
		_player.add_weapon(weapon)

func purchase_upgrade(name):
	var upgrade = PlayerState.upgrade_from_string(name)
	Log.Info("Attempting to purchase %s" % name)
	if credits >= PlayerState.COST[upgrade]:
		get_tree().create_tween().tween_method(set_credits_value, credits, credits - PlayerState.COST[upgrade], 1)
		_player.add_upgrade(upgrade)

func add_collected_credits():
	if (PlayerState.credits_earned != 0):
		get_tree().create_tween().tween_method(set_credits_value, credits, credits + PlayerState.credits_earned, 1)	
	PlayerState.credits_earned = 0	
	
func set_credits_value(val):
	credits = val
