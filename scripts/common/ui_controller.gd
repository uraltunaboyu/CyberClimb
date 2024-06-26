extends Node

var _ui_node: Node

func _initialize():
	_ui_node = get_tree().current_scene.find_child("UI")
	
	set_max_hp(PlayerState.maxHp)
	set_cur_hp(PlayerState.hp)
	set_max_stamina(PlayerState.maxStamina)
	set_cur_stamina(PlayerState.stamina)
	set_ammo(PlayerState.ammo)

func set_cur_hp(val):
	_ui_node.healthBar.value = val
	
func set_max_hp(val):
	_ui_node.healthBar.max_value = val

func set_cur_stamina(val):
	_ui_node.staminaBar.value = val
	
func set_max_stamina(val):
	_ui_node.staminaBar.max_value = val
	
func set_ammo(val):
	if not _ui_node: return
	if val:
		_ui_node.ammoText.visible = true
		_ui_node.ammoText.text = "Ammo: " + str(val)
	else:
		_ui_node.ammoText.visible = false

func set_movement_state(val):
	if Debug.DEBUG_MODE:
		_ui_node.movementStateText.text = val

func enable_crosshair():
	_ui_node.crosshair.visible = true
	
func disable_crosshair():
	_ui_node.crosshair.visible = false

func set_prompt(val):
	_ui_node.promptText.text = val
