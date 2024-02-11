extends Node

#@onready var player = get_node("res://scripts/Player.gd")
@onready var player : Node = get_node("/root/MainScene/Player")
var upgrade;

# Called when the node enters the scene tree for the first time.
func _ready():
	upgrade = player.get_upgrade()
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


#exit button pressed
func _on_exit_pressed():
	pass # Replace with function body.

#Buttons in order of left to right, top row down
#buy functions
func _on_button_1_pressed():
	if ($MarginContainer2/GridContainer/VBoxContainer1/Button1.text == "Buy"):
		$MarginContainer2/GridContainer/VBoxContainer1/Button1.text = "Bought"
		upgrade.set_value("max_hp", 10)
	pass # Replace with function body.


func _on_button_2_pressed():
	if ($MarginContainer2/GridContainer/VBoxContainer2/Button2.text == "Buy"):
		$MarginContainer2/GridContainer/VBoxContainer2/Button2.text = "Bought"
		upgrade.set_value("jump_force", 10)
	pass # Replace with function body.


func _on_button_3_pressed():
	if ($MarginContainer2/GridContainer/VBoxContainer3/Button3.text == "Buy"):
		$MarginContainer2/GridContainer/VBoxContainer3/Button3.text = "Bought"
		upgrade.set_value("move_speed", 10)
	pass # Replace with function body.


func _on_button_4_pressed():
	if ($MarginContainer2/GridContainer/VBoxContainer4/Button4.text == "Buy"):
		$MarginContainer2/GridContainer/VBoxContainer4/Button4.text = "Bought"
		upgrade.set_value("start_ammo", 10)
	pass # Replace with function body.


func _on_button_5_pressed():
	if ($MarginContainer2/GridContainer/VBoxContainer5/Button5.text == "Buy"):
		$MarginContainer2/GridContainer/VBoxContainer5/Button5.text = "Bought"
		upgrade.set_value("magic_reload", true)
	pass # Replace with function body.


func _on_button_6_pressed():
	if ($MarginContainer2/GridContainer/VBoxContainer6/Button6.text == "Buy"):
		$MarginContainer2/GridContainer/VBoxContainer6/Button6.text = "Bought"
		upgrade.set_value("cheat_death", true)
	pass # Replace with function body.


func _on_button_7_pressed():
	if ($MarginContainer2/GridContainer/VBoxContainer7/Button7.text == "Buy"):
		$MarginContainer2/GridContainer/VBoxContainer7/Button7.text = "Bought"
		upgrade.set_value("lifesteal", true)
	pass # Replace with function body.


func _on_button_8_pressed():
	if ($MarginContainer2/GridContainer/VBoxContainer8/Button8.text == "Buy"):
		$MarginContainer2/GridContainer/VBoxContainer8/Button8.text = "Bought"
		# code of effect of item bought
	pass # Replace with function body.

#future implementation of populating page?
func _on_previous_pressed():
	pass # Replace with function body.


func _on_next_pressed():
	pass # Replace with function body.
