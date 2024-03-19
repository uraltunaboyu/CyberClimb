class_name LevelController extends Node

var all_rooms = {'theme 1' : ["res://Rooms/TestLevel.tscn", "res://Rooms/TestLevel.tscn", "res://Rooms/TestLevel.tscn", "res://Rooms/TestLevel.tscn", "res://Rooms/TestLevel.tscn", 'boss'], 'theme2' : [1, 2, 3, 4, 5, 'boss']}
var room_order : Array
var diff = 1

func set_room_order()->void:
	randomize()
	for level in all_rooms.keys():
		var room_levels
		var boss_index = all_rooms[level].size() - 1
		room_levels = all_rooms[level].slice(0,boss_index)
		room_levels.shuffle()
		room_levels = room_levels.slice(0,2)
		room_levels.append(all_rooms[level][boss_index])
		room_order.append(room_levels)
		
func get_room_json(room:String)->String:
	var name = get_tree().get_current_scene().get_name()
	var file = "res://room_info/" + name + ".json"
	var json_content = FileAccess.get_file_as_string(file)
	return json_content
	
func go_next_room(reward:String)->int:
	print(reward)
	GameState.load_scene_by_path(room_order[0][0])
	print('generated')
	diff += 1
	room_order.remove_at(0)
	return(diff)

# 'rooms/room1.json' --> {info}
# curr_room = new Room()
#
