extends Node


@onready var hub_music = load("res://audio/music/Motherboard.mp3")
@onready var combat_music = load("res://audio/music/Error 407 (QA 1).mp3")

var default_audio = 20.0
var _player: AudioStreamPlayer
var playing: bool = false:
	get:
		return _player.playing

func _reset_player(track):
	if _player == null:
		_player = AudioStreamPlayer.new()
		if Debug.DEBUG_MODE:
			_player.volume_db = -50
		else:
			_player.volume_db = -10
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
	
func toggle_mute():
	var mute_status = _player.get_stream_paused()
	_player.set_stream_paused(!mute_status)
