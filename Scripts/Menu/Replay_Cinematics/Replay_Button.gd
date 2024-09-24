extends TextureButton

@export var cinematic_to_play : PackedScene

func _ready():
	var temp_instance := cinematic_to_play.instantiate()
	if SaveSystem.get_curr_file().cinematics_played.has(temp_instance.id_cinematic):
		disabled = false
	temp_instance.queue_free()

func _on_pressed():
	var cinematic_instance := cinematic_to_play.instantiate()
	cinematic_instance.scene_to_enter = load("res://Scenes/Menu/main_menu.tscn")
	Events.change_scene_instance.emit(cinematic_instance)
