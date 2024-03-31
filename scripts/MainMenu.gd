extends Control



# Called when the node enters the scene tree for the first time.
func _ready():
	AudioController.play_hub_music()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

@onready var OptionMenu = $OptionMenu
@onready var MuteButton = $OptionMenu/MuteButton
@onready var BackButton = $OptionMenu/BackButton
var music_bus = AudioServer

func _on_start_button_pressed():
	GameState.load_scene_by_path("res://scenes/MainScene.tscn")

func _on_option_button_pressed():
	OptionMenu.z_index = 1
	MuteButton.disabled = false
	BackButton.disabled = false

func _on_quit_button_pressed():
	get_tree().quit()

func _on_credits_button_pressed():
	GameState.load_scene_by_path("res://scenes/credits-scene/credits.tscn")

func _on_back_button_pressed():
	OptionMenu.z_index = -1
	MuteButton.disabled = true
	BackButton.disabled = true

func _on_mute_button_pressed():
	AudioController.toggle_mute()
