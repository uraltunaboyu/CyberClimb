extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	transition()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func show_game_over(text):
	$Message.text = text
	$Message.show()
	await get_tree().create_timer(2.0).timeout

func transition():
	$AnimationPlayer.play("fade_to_black")
	
