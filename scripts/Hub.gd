extends Node

const SHOTGUN_PRICE = 100
const SHOTGUN_SCENE = "res://scenes/Shotgun.tscn"

@onready var _credits_text = $CanvasLayer/HubUI/CreditsText
@onready var _player = $Player
@onready var credits: int:
	get:
		return PlayerState.credits
	set(_credits):
		_credits_text.text = "Credits: " + str(_credits)
		PlayerState.credits = _credits

func _ready():
	credits = PlayerState.credits

func purchase_weapon(name):
	var weapon = WeaponAttributes.BY_NAME[name]
	Log.Info("Attempting to purchase %s" % name)
	if credits >= WeaponAttributes.COST[weapon]:
		credits -= WeaponAttributes.COST[weapon]
		_player.add_weapon(weapon)

func _goto_boss(_a):
	GameState.load("res://Rooms/BossRoom.tscn")
