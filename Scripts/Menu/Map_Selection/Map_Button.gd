extends TextureButton

## Mapa al que se entra al presionar el botón.
@export var map_to_enter : PackedScene
## El slime que desbloquea este mapa.
@export var unlocked_by_slime : PackedScene
## La cinemática que se reproduce al iniciar el nivel.
## Si ya fue vista, no se vuelve a reproducir.
@export var cinematic_to_play : PackedScene

func _ready() -> void:
	connect("pressed", _on_pressed)
	
	if not Vars.slimes_unlocked.has(unlocked_by_slime):
		disabled = true

func _on_pressed() -> void:
	Funcs.sound_play("res://Sounds/uiclick.mp3", 20)
	Save_System.reset_map_state()
	
	if cinematic_to_play == null:
		Events.change_scene_packed.emit(map_to_enter)
		return
	
	var cinematic_instance := cinematic_to_play.instantiate()
	if not Vars.cinematics_played.has(cinematic_instance.id_cinematic):
		cinematic_instance.scene_to_enter = map_to_enter
		Events.change_scene_instance.emit(cinematic_instance)
	else:
		cinematic_instance.queue_free()
		Events.change_scene_packed.emit(map_to_enter)
