extends Node3D

@onready var ap : AnimationPlayer = $AnimationPlayer
@onready var labcon : Node3D = $LabelContainer
@onready var label : Label3D = $LabelContainer/DamageLabel

# Visually tested for these numbers, could use some tweaking.
var max_font_size : int = 3000
var min_font_size : int = 400

func set_and_animate(value:float, chunk:float, start_pos:Vector3, height:float = 0.5, spread:float = 1.5):
	# Set the DamageLabel text to the damage.
	label.text = str(value)
	# Calculate the text size based on the % hp loss. Assumed this usually won't
	# surpass 30%
	var f_size : float = chunk*3*max_font_size + min_font_size
	label.font_size = f_size
	label.outline_size = f_size/10
	
	# Play the animation (grows/shrinks text + alpha modulation)
	ap.play("DamagePopUp")
	
	# Create a tween and its inputs based on the function inputs.
	var tween : Tween = create_tween()
	var end_pos : Vector3 = Vector3(randf_range(-spread, spread), height, randf_range(-spread,spread)) + start_pos
	var tween_length : float = ap.get_animation("DamagePopUp").length
	
	# "Play" the tween.
	tween.tween_property(labcon, "position", end_pos, tween_length).from(start_pos + Vector3(0, 0.5, 0))
	
func remove():
	# Called in the animation to remove it from existence.
	queue_free()
