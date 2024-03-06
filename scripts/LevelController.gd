class_name LevelController extends Node

var room_levels = ['level1', 'level2', 'level3', 'level4', 'level5']
var room_order
var boss_room
var room_index = 0
var curr_room
var curr_level
var level_index
var story_levels
var current_stage = 0
var current_level = 0


func set_room_order()->void:
	randomize()
	room_order = room_levels
	room_order.shuffle()
	room_order.append(boss_room)

func go_next_room()->void:
	curr_room = room_order[room_index]
	curr_room.generate()
	if room_index == 6:
		room_index = 0 #maybe should be done after the room is completed in case of failure
		level_index += 1
	else:
		room_index += 1
