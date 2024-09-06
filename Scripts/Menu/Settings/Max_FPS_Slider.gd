extends HSlider

@onready var max_fps_label := get_parent().get_node("Max_FPS_Amount")
func _ready():
	value = Vars.settings_data.max_fps
	Engine.max_fps = Vars.settings_data.max_fps
	max_fps_label.text = get_fps_with_zero()

func _on_value_changed(val):
	Vars.settings_data.max_fps = val
	Engine.max_fps = val
	max_fps_label.text = get_fps_with_zero()
	
	Save_System.save_settings()

# Si los fps es de una cifra, se le agrega un cero adelanta, y si no entonces queda igual
func get_fps_with_zero() -> String:
	var fps := str(Engine.max_fps)
	if fps.length() == 1:
		fps = "0" + fps
	return fps
