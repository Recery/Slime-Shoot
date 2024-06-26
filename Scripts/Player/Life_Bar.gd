extends Sprite2D

var newSize

func _process(_delta):
	newSize = (float(get_parent().life) / float(get_parent().max_life)) * 141
	get_node("ColorRect").size.x = lerp(get_node("ColorRect").size.x , newSize, 0.5)
