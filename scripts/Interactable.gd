class_name Interactable
extends StaticBody3D

signal interacted(target_scene)

@export var prompt_message = "Interact Message"
@export var prompt_action = "interact"
@export var target_scene : String

func get_prompt():
	var key_name = ""
	for action in InputMap.action_get_events(prompt_action):
		if action is InputEventKey:
			key_name = OS.get_keycode_string(action.physical_keycode)
	return prompt_message + "\n[ " + key_name + " ]"
	
func interact():
	interacted.emit(target_scene)

func get_printed(text:String):
	print(text)
