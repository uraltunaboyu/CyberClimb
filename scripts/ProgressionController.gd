extends Node

enum ProgressionFlag {
	NONE,
	TUTORIAL,
	FIRST_BOSS
}

var completed_flags = [ProgressionFlag.NONE]
var completed_dialog = {}

func is_flag_complete(flag: ProgressionFlag) -> bool:
	return completed_flags.has(flag)
	
func complete_flag(flag: ProgressionFlag):
	completed_flags.append(flag)
	
func latest_flag() -> ProgressionFlag:
	# this is not great
	return completed_flags[completed_flags.size() - 1]

func complete_dialog(npc_name: String, index: int):
	completed_dialog[npc_name] = index
	
func latest_completed_dialog(npc_name : String) -> int:
	if not completed_dialog.has(npc_name):
		completed_dialog[npc_name] = -1
	return completed_dialog[npc_name]
	
