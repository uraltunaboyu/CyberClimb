extends RayCast3D

@onready var prompt = $Prompt
# Called when the node enters the scene tree for the first time.
func _ready():
	add_exception(owner)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	UIController.set_prompt("")
	if is_colliding():
		var detected = get_collider()
		
		if detected is Interactable:
			UIController.set_prompt(detected.get_prompt())
			
			if Input.is_action_just_pressed(detected.prompt_action):
				detected.interact()

