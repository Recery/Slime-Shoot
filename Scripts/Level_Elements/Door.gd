@tool
extends StaticBody2D

## Si empieza abierta o cerrada
@export var open := true
## Si es horizontal o vertical
@export var horizontal = false

@export_group("Connections")
@export var emitter_nodes : Array[NodeAndSignal]
## Si se abre solo con una señal
@export var one_signal_toggle := false

var main_tilemap : TileMap

signal open_and_close(first_time)

func _ready() -> void:
	set_orientation()
	
	if Engine.is_editor_hint(): return
	for child in Funcs.get_all_children(Vars.main_scene):
		if child.is_in_group("Main_Tiles"): main_tilemap = child
	open_and_close.emit(true)
	connect_signals()

func _process(_delta):
	if not Engine.is_editor_hint():
		set_process(false)
		return
	set_orientation()

func set_orientation():
	if horizontal:
		get_node("Sprite2D").texture = load("res://Sprites/Level_Elements/DoorHorizontal.png")
		get_node("Sprite2D").hframes = 2
		get_node("CollisionShape2D").shape = load("res://Scenes/Level_Elements/collision_door_horizontal.tres")
	else:
		get_node("Sprite2D").texture = load("res://Sprites/Level_Elements/Door.png")
		get_node("Sprite2D").hframes = 1
		get_node("CollisionShape2D").shape = load("res://Scenes/Level_Elements/collision_door_vertical.tres")

func connect_signals() -> void:
	for node in emitter_nodes:
		node.init_node(self)
		node.emitter_node.connect(node.signal_name, activation_emitted)
		node.activated = false

func on_open_and_close(first_time := false) -> void:
	if not first_time: 
		open = not open
		get_node("Sound").play()
	if open:
		get_node("CollisionShape2D").set_deferred("disabled", true)
		if horizontal:
			get_node("Sprite2D").frame = 1
		else: visible = false
	else: 
		get_node("CollisionShape2D").set_deferred("disabled", false)
		if horizontal: get_node("Sprite2D").frame = 0
		else: visible = true
	set_shadows_tiles()

func set_shadows_tiles():
	# Dependiendo de si está abierta o cerrada, coloca tiles de sombra o los elimina
	
	var tiles_pos : Array[Vector2i]
	if horizontal:
		tiles_pos = [
		main_tilemap.local_to_map(Vector2i(int(position.x) + 8, int(position.y) + 16)),
		main_tilemap.local_to_map(Vector2i(int(position.x) - 8, int(position.y) + 16))
		]
	else:
		tiles_pos = [
		main_tilemap.local_to_map(Vector2i(int(position.x), int(position.y))),
		main_tilemap.local_to_map(Vector2i(int(position.x), int(position.y) + 16))
		]
	get_atlas_original_tiles(tiles_pos)
	
	if open:
		main_tilemap.erase_cell(1, tiles_pos[0])
		main_tilemap.erase_cell(1, tiles_pos[1])
		main_tilemap.set_cell(0, tiles_pos[0], 0, atlas_coords_original[0])
		main_tilemap.set_cell(0, tiles_pos[1], 0, atlas_coords_original[1])
	if not open and horizontal:
		main_tilemap.erase_cell(0, tiles_pos[0])
		main_tilemap.erase_cell(0, tiles_pos[1])
		main_tilemap.set_cell(1, tiles_pos[0], 0, main_tilemap.tiles_shadows_door.h_close_shadows_1)
		main_tilemap.set_cell(1, tiles_pos[1], 0, main_tilemap.tiles_shadows_door.h_close_shadows_2)
	elif not open and not horizontal:
		main_tilemap.erase_cell(0, tiles_pos[0])
		main_tilemap.erase_cell(0, tiles_pos[1])
		main_tilemap.set_cell(1, tiles_pos[0], 0, main_tilemap.tiles_shadows_door.v_close_shadows_1)
		main_tilemap.set_cell(1, tiles_pos[1], 0, main_tilemap.tiles_shadows_door.v_close_shadows_2)

var atlas_coords_original : Array[Vector2i]
func get_atlas_original_tiles(pos_tiles : Array[Vector2i]) -> void:
	if atlas_coords_original.size() > 0: return
	atlas_coords_original.append(main_tilemap.get_cell_atlas_coords(0, pos_tiles[0]))
	atlas_coords_original.append(main_tilemap.get_cell_atlas_coords(0, pos_tiles[1]))

@onready var toggled = false
var activated_by : Node
func activation_emitted(emitter : Node) -> void:
	var all_signals_true := true
	
	for node in emitter_nodes:
		if emitter == node.emitter_node:
			node.activated = not node.activated
		if not node.activated: all_signals_true = false
	
	if not one_signal_toggle:
	# Si alguna señal esta desactivada y la puerta esta activada...
		if not all_signals_true && toggled:
			# Desactivarla
			toggled = false
			open_and_close.emit()
		# Sino si todas las señales están activadas y la puerta esta desactivada...
		elif all_signals_true && not toggled:
			# Activarla
			toggled = true
			open_and_close.emit()
	
	if one_signal_toggle:
		if toggled && activated_by == emitter:
			toggled = not toggled
			open_and_close.emit()
		elif not toggled:
			activated_by = emitter
			toggled = not toggled
			open_and_close.emit()
