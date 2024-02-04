extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


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
		# code of effect of item bought
	pass # Replace with function body.


func _on_button_2_pressed():
	if ($MarginContainer2/GridContainer/VBoxContainer2/Button2.text == "Buy"):
		$MarginContainer2/GridContainer/VBoxContainer2/Button2.text = "Bought"
		# code of effect of item bought
	pass # Replace with function body.


func _on_button_3_pressed():
	if ($MarginContainer2/GridContainer/VBoxContainer3/Button3.text == "Buy"):
		$MarginContainer2/GridContainer/VBoxContainer3/Button3.text = "Bought"
		# code of effect of item bought
	pass # Replace with function body.


func _on_button_4_pressed():
	if ($MarginContainer2/GridContainer/VBoxContainer4/Button4.text == "Buy"):
		$MarginContainer2/GridContainer/VBoxContainer4/Button4.text = "Bought"
		# code of effect of item bought
	pass # Replace with function body.


func _on_button_5_pressed():
	if ($MarginContainer2/GridContainer/VBoxContainer5/Button5.text == "Buy"):
		$MarginContainer2/GridContainer/VBoxContainer5/Button5.text = "Bought"
		# code of effect of item bought
	pass # Replace with function body.


func _on_button_6_pressed():
	if ($MarginContainer2/GridContainer/VBoxContainer6/Button6.text == "Buy"):
		$MarginContainer2/GridContainer/VBoxContainer6/Button6.text = "Bought"
		# code of effect of item bought
	pass # Replace with function body.


func _on_button_7_pressed():
	if ($MarginContainer2/GridContainer/VBoxContainer7/Button7.text == "Buy"):
		$MarginContainer2/GridContainer/VBoxContainer7/Button7.text = "Bought"
		# code of effect of item bought
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
