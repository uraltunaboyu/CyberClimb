extends Control

@onready var healthBar : TextureProgressBar = get_node("HealthBar")
@onready var ammoText : Label = get_node("AmmoText")

func update_health_bar (curHp, maxHp):
	healthBar.max_value = maxHp
	healthBar.value = curHp
	
func update_ammo_text (ammo):
	ammoText.text = "Ammo: " + str(ammo)
