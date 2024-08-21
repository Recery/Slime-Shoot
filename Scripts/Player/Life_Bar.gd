extends Sprite2D

@onready var rect := get_node("ColorRect")
@onready var life_display_label := get_node("Life_Display")

func _process(_delta):
	var new_size = (float(get_parent().life) / float(get_parent().max_life)) * 141
	rect.size.x = lerp(rect.size.x , new_size, 0.5)
	life_display_label.text = str(int(get_parent().life)) + "/" + str(int(get_parent().max_life))
