extends Interactable

# Called when the node enters the scene tree for the fir st time.
func _ready():
	target_scene = "money"
	var root = get_tree().root.get_child(-1)
	if root.has_method("_next_room"):
		interacted.connect(root._next_room)
	else:
		interacted.connect(GameState.room_transition)

