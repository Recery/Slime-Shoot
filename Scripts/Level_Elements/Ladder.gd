@tool
extends Activable

@export var map_to_enter : String

## Si esta ladder tiene el sprite de arriba.
## Si es false, tendra el sprite para ir abajo.
@export var up := false

func _ready() -> void:
	if not Engine.is_editor_hint(): set_process(false)
	set_sprite_frame()

func _process(_delta) -> void:
	set_sprite_frame()

func set_sprite_frame() -> void:
	if up: get_node("Sprite2D").frame = 1
	else: get_node("Sprite2D").frame = 0

func _input(event) -> void:
	if event.is_action_pressed("interact") and player_in_area:
		activated.emit(self)
		Events.change_scene.emit(map_to_enter)
