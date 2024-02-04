extends Node3D

@onready var ap : AnimationPlayer = $AnimationPlayer
@onready var labcon : Node3D = $LabelContainer
@onready var label : Label3D = $LabelContainer/DamageLabel

var max_font_size = 3000
var min_font_size = 400

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_and_animate(value:float, start_pos:Vector3,height:float = 0.5, spread:float = 2.0):
	label.text = str(value)
	var f_size = min(max((2*value)**2*10, min_font_size), max_font_size)
	label.font_size = f_size
	label.outline_size = f_size/10
	ap.play("DamagePopUp")
	
	var tween = create_tween()
	var end_pos = Vector3(randf_range(-spread, spread), height, randf_range(-spread,spread)) + start_pos
	var tween_length = ap.get_animation("DamagePopUp").length
	
	tween.tween_property(labcon, "position", end_pos, tween_length).from(start_pos - Vector3(0, 0.5, 0))
	
func remove():
	queue_free()
