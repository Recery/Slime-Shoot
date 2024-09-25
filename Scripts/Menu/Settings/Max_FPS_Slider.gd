extends HSlider

@onready var max_fps_label := get_parent().get_node("Max_FPS_Amount")
func _ready():
	value = SaveSystem.get_curr_file().save_settings.max_fps
	Engine.max_fps = SaveSystem.get_curr_file().save_settings.max_fps
	max_fps_label.text = get_fps_with_zero()

func _on_value_changed(val):
	SaveSystem.get_curr_file().save_settings.max_fps = val
	Engine.max_fps = val
	max_fps_label.text = get_fps_with_zero()
	
	SaveSystem.save_file()

# Si los fps es de una cifra, se le agrega un cero adelante, y si no entonces queda igual
func get_fps_with_zero() -> String:
	var fps := str(Engine.max_fps)
	if fps.length() == 1:
		fps = "0" + fps
	return fps
