extends Sprite2D

var newSize

func _process(_delta):
	newSize = (float(get_parent().energy) / float(get_parent().max_energy)) * 141
	get_node("ColorRect").size.x = lerp(get_node("ColorRect").size.x , newSize, 0.5)
	
	if not get_parent().can_use_energy:
		get_node("ColorRect").color = Color(0.670, 0.670, 0.670)
	else:
		get_node("ColorRect").color = Color(0.922, 0.906, 0.137)
