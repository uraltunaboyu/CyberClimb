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
	AudioController.play_hub_music()
	UIController.disable_crosshair()

func purchase_weapon(name):
	var weapon = WeaponAttributes.BY_NAME[name]
	Log.Info("Attempting to purchase %s" % name)
	if credits >= WeaponAttributes.COST[weapon]:
		credits -= WeaponAttributes.COST[weapon]
		_player.add_weapon(weapon)

func purchase_upgrade(name):
	var upgrade = PlayerState.upgrade_from_string(name)
	Log.Info("Attempting to purchase %s" % name)
	if credits >= PlayerState.COST[upgrade]:
		credits -= PlayerState.COST[upgrade]
		_player.add_upgrade(upgrade)
