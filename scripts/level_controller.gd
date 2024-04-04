class_name LevelController extends Node

var all_rooms = {'theme 1' : [
	"res://scenes/levels/level1-1.tscn",
	"res://scenes/levels/level1-2.tscn",
	"res://scenes/levels/level1-4.tscn",
	"res://scenes/levels/level1-5.tscn",
	"res://scenes/levels/level1-boss.tscn" 
	]}
var room_order = []
var diff = 1

func _init():
	self.set_room_order()
	
func set_room_order()->void:
	randomize()
	for theme in all_rooms.keys():
		var room_levels
		var boss_index = all_rooms[theme].size() - 1
		room_levels = all_rooms[theme].slice(0,boss_index)
		room_levels.shuffle()
		room_levels.append(all_rooms[theme][boss_index])
		room_order.append_array(room_levels)
	
func go_next_room(reward:String)->int:
	GameState.load_scene_by_path(room_order[0])
	AudioController.play_combat_music()
	diff += 1
	room_order.remove_at(0)
	return(diff)
