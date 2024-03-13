class_name LevelController extends Node

var all_rooms = {'theme 1' : ['1', 2, 3, 4, 5, 'boss'], 'theme2' : [1, 2, 3, 4, 5, 'boss']}
var room_order
var diff = 1

func set_room_order()->void:
	randomize()
	for level in all_rooms.keys():
		var room_levels
		var boss_index = all_rooms[level].size() - 1
		room_levels = all_rooms[level].slice(0,boss_index - 1)
		room_levels.shuffle()
		room_levels = room_levels.slice(0,2)
		room_levels.append(all_rooms[level][boss_index])
		room_order.append(room_levels)
		
func get_room_json(room:String)->String:
	var name = get_tree().get_current_scene().get_name()
	var file = "res://room_info/" + name + ".json"
	var json_content = FileAccess.get_file_as_string(file)
	print('parsing')
	# change extension
	return json_content
	

func go_next_room(reward:String)->void:
	#something to black out the screen HERE change game state
	var curr_room = room_order[0] #scene path
	var loaded_room = load(curr_room)
	loaded_room.instantiate()
	get_node('/root/MainScene').add_child(loaded_room) # check how to change scenes more optimally
	var room_json = get_room_json(curr_room)
	loaded_room.load_info(room_json)
	var status = loaded_room.generate(reward, diff)
	if status:
		print('generated')
		# make the game state playable again
		diff += 1
		room_order.remove_at(0)
	else:
		print('crash')

# 'rooms/room1.json' --> {info}
# curr_room = new Room()
#
