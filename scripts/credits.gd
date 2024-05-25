extends Control

# LOGIC 
var done = false # True if all the credits have been scrolled off the screen
#				 # (don't change this value, to end just use "end" function)
var is_first_frame = true
var viewSize # The size of the window
@export var nextScene: PackedScene

# SPEED CONTROLS
@export var scrolling_base_speed := 100
@export var speed_up_multiplier := 10.0
var scroll_speed := scrolling_base_speed
var speed_up := false

# TITLE IMAGE
@export var title_texture: Texture2D
@onready var title_image = get_node("scrollingCreditsContainer/titleImage")

# TEXT
@onready var scrollingTextScene = preload("res://scenes/scrolling_text.tscn")
@onready var scrolling_credits_container = get_node("scrollingCreditsContainer")
var credits = [
	[["Technical Lead"],["Ural"]],
	[["Creative Lead"],["Max"]],
	[["Writing and Worldbuilding"],["Alwyn", "Hanna", "Matt", "Max", "Sarah", "Zheng"]],
	[["Programming"],["Kagan", "Ural"]],
	[["Junior Programming"],["Brandon", "Liam", "Max", "Ryan", "Senlin"]],
	[["Concept Art"],["Ariel"]],
	[["Menu Design"],["Andrew"]],
	[["Music Composition & Sound Design"],["Matt"]],
	[["Level Design"],["Max", "Nico", "Paige"]],
	[["Enemy Design"],["Max"]],
]
# Color of the text on left side
@export var titles_color: Color = Color.GRAY
# Color of the text on right side
@export var names_color: Color = Color.WHITE
# Custom font
@export var custom_font: Font
# Font size of Title text (Technical Lead, etc.)
@export var titles_font_size := 32
# Font size of Names text (Ural, etc.)
@export var names_font_size := 32
# Margin of titles from center
@export var title_separation := 8
# Margin of names from center
@export var name_separation := 8
# Margine of both from title image
@export var top_margin := 16

# BACKGROUND
@onready var background = get_node("background")
var background_color: Color = Color.BLACK

# Called when the node enters the scene tree for the first time.
func _ready():
	viewSize = get_viewport().size
	scrolling_credits_container.position.y = viewSize.y * 2 # it's multiplied by two as a workaround. Look at _process function
	scroll_speed = scrolling_base_speed
	
	$background.color = background_color
	
	var scrolling_text = scrollingTextScene.instantiate()
	var titles = scrolling_text.get_node("margin/Titles")
	var names = scrolling_text.get_node("margin2/Names")
	
	# Set colors
	titles.add_theme_color_override("font_color",titles_color)
	names.add_theme_color_override("font_color",names_color)
	
	# set size
	titles.add_theme_font_size_override("font_size", titles_font_size)
	names.add_theme_font_size_override("font_size", names_font_size)
	
	# Set the custom font (if there is one)
	if custom_font != null:
		titles.add_theme_font_override("font", custom_font)
		names.add_theme_font_override("font", custom_font)
	
	scrolling_credits_container.add_child(scrolling_text)
	
	# Set the margin (the space between left and right panels)
	scrolling_text.get_node("margin").add_theme_constant_override("margin_top", top_margin)
	scrolling_text.get_node("margin2").add_theme_constant_override("margin_top", top_margin)
	@warning_ignore("integer_division")
	scrolling_text.get_node("margin").add_theme_constant_override("margin_right", title_separation)
	@warning_ignore("integer_division")
	scrolling_text.get_node("margin2").add_theme_constant_override("margin_left", name_separation)
		
	for i in credits.size():
		# each credit[i] has two elements, one is title, and other is listOf names
		titles.text += credits[i][0][0]
		for j in credits[i][1].size():
			titles.text += "\n"
			names.text += credits[i][1][j] + "\n"
		titles.text += "\n"
		names.text += "\n"
	

	# Set title image if there is one, otherwise delete the useless node
	if title_image != null:
		title_image.texture = title_texture
	else:
		title_image.queue_free()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var scroll = scroll_speed * delta
	
	if is_first_frame:
		viewSize = get_viewport().size
		scrolling_credits_container.position.y = viewSize.y
		is_first_frame = false
	
	if not done:
		# If the scroll is not yet ended, keep to scroll it
		if scrolling_credits_container.position.y + scrolling_credits_container.size.y > 0:
			scrolling_credits_container.position.y -= scroll
		else:
			end()
			
	if speed_up:
		scroll_speed *= speed_up_multiplier
	else:
		scroll_speed /= speed_up_multiplier
		if (scroll_speed < scrolling_base_speed):
			scroll_speed = scrolling_base_speed
	pass

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		end()
	if event.is_action_pressed("ui_down"):
		speed_up = true
	if event.is_action_released("ui_down"):
		speed_up = false

# Use this function to stop all
func end():
	emit_signal("ended") # Emit a signal to make easy for programmers to connect other things to this
	done = true # And a var, to make things even more easy to connect
	
	# If there is a next scene to load, then load it,
	# otherwise if quitOnEnd is enabled, just quit
	if nextScene != null:
		# warning-ignore:return_value_discarded
		get_tree().change_scene_to_file(nextScene.get_path())
