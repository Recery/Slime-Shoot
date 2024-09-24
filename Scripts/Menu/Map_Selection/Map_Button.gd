extends TextureButton

## Mapa al que se entra al presionar el botón.
@export var map_to_enter : PackedScene
## El slime que desbloquea este mapa.
@export var unlocked_by_slime : PackedScene
## La cinemática que se reproduce al iniciar el nivel.
## Si ya fue vista, no se vuelve a reproducir.
@export var cinematic_to_play : PackedScene
## El nombre del mapa, se muestra en un cuadro abajo al hacer hover sobre el boton. Solo es estetico
@export var map_name : String

func _ready() -> void:
	pressed.connect(_on_pressed)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	Events.save_file_changed.connect(check_enabled)
	check_enabled()

func check_enabled() -> void:
	disabled = not SaveSystem.get_curr_file().save_equipment.unlocked_slimes.has(unlocked_by_slime)

func _on_pressed() -> void:
	Funcs.sound_play("res://Sounds/uiclick.mp3", 20)
	MapStates.reset_map_state()
	
	if cinematic_to_play == null:
		Events.change_scene_packed.emit(map_to_enter)
		return
	
	var cinematic_instance := cinematic_to_play.instantiate()
	if not SaveSystem.get_curr_file().cinematics_played.has(cinematic_instance.id_cinematic):
		cinematic_instance.scene_to_enter = map_to_enter
		Events.change_scene_instance.emit(cinematic_instance)
	else:
		cinematic_instance.queue_free()
		Events.change_scene_packed.emit(map_to_enter)

func _on_mouse_entered():
	if get_parent().get_parent().has_node("Map_Name_Label"):
		if disabled:
			get_parent().get_parent().get_node("Map_Name_Label").text = "Locked map!"
		else:
			get_parent().get_parent().get_node("Map_Name_Label").text = map_name

func _on_mouse_exited():
	if get_parent().get_parent().has_node("Map_Name_Label"):
		get_parent().get_parent().get_node("Map_Name_Label").text = "Choose a map!"
