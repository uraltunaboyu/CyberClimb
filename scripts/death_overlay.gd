extends CanvasLayer

var callback: Callable

const FADE_DURATION = 2.0
const HANG_DURATION = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	transition()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_text(text):
	$Message.text = text

func transition():
	var overlay_tween = create_tween()
	# fade to black
	overlay_tween.tween_property($ColorRect, "color", Color.BLACK, FADE_DURATION)
	# fade in text
	overlay_tween.parallel().tween_property($Message, "modulate:a", 1.0, FADE_DURATION)
	overlay_tween.chain().tween_interval(HANG_DURATION)
	if callback != null:
		overlay_tween.chain().tween_callback(callback)

func set_callback(c: Callable):
	callback = c
