extends Interactable

# Called when the node enters the scene tree for the first time.
func _ready():
	target_scene = "money"
	interacted.connect(GameState.room_transition)

