extends Node


@onready var hub_music = load("res://audio/music/Motherboard.mp3")
@onready var combat_music = load("res://audio/music/Motherboard.mp3")

var _player: AudioStreamPlayer
var playing: bool = false:
	get:
		return _player.playing
		
func _reset_player(track):
	if _player == null:
		_player = AudioStreamPlayer.new()
		add_child(_player)
		_player.stream = track
	elif _player.stream != track:
		_player.stop()
		_player.stream = track
	if not _player.playing:
		_player.play()

func play_hub_music():
	_reset_player(hub_music)
	
func play_combat_music():
	_reset_player(combat_music)
