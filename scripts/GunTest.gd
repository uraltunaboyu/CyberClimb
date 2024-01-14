extends Node3D

@onready var AnimPlayer = $AnimationPlayer
@onready var Sound = $Shot

func _ready():
	pass 

func Shoot():
	if AnimPlayer.is_playing():
		pass
	else:
		AnimPlayer.play("Kick")
		Sound.set_pitch_scale(randf_range(.7,.9))
