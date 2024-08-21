extends Sprite2D

@onready var player := get_parent()

@onready var rect := get_node("ColorRect")
@onready var energy_display_label := get_node("Energy_Display")

func _process(_delta):
	if not player is Player or player == null: return
	
	var new_size = (float(player.energy) / float(player.max_energy)) * 141
	rect.size.x = lerp(rect.size.x , new_size, 0.5)
	
	if not get_parent().can_use_energy:
		rect.color = Color(0.670, 0.670, 0.670)
	else:
		rect.color = Color(0.922, 0.906, 0.137)
	
	energy_display_label.text = str(int(player.energy)) + "/" + str(int(player.max_energy))
