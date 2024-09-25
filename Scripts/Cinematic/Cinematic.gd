extends Control
class_name Cinematic

## Todos los frames que se muestran en la
## cinemática, en orden del primero al último.
@export var cinematic_frames : Array[CinematicFrame]

## La escena a la que se ingresa al terminar la cinemática.
@export var scene_to_enter : PackedScene
## El ID de la cinematica, se usa para distintas instrucciones
## en el juego que implican cinematicas.
@export var id_cinematic := 0

var sprite : Sprite2D
var text_frame : Label
var anykey_text : Label

var current_frame := 0

var playing_fade_effect := true

func _ready():
	create_children()
	modulate.a = 0
	
	await Funcs.fade_effect(self, true)
	playing_fade_effect = false

func create_children():
	anykey_text = Label.new()
	anykey_text.label_settings = load("res://Resources/Setted_Resources/cinematic_description_text.tres")
	add_child(anykey_text)
	anykey_text.position = Vector2(-135, -75)
	anykey_text.text = "Press any key to continue..."
	
	var camera := Camera2D.new()
	camera.zoom = Vector2(4,4)
	add_child(camera)
	
	if cinematic_frames.size() <= 0: return
	
	sprite = Sprite2D.new()
	sprite.texture = cinematic_frames[0].frame
	add_child(sprite)
	
	text_frame = load("res://Scenes/Cinematic/cinamatic_text_label.tscn").instantiate()
	add_child(text_frame)
	text_frame.text = cinematic_frames[0].text

func _input(event):
	if event is InputEventKey and event.is_released() and not playing_fade_effect:
		next_frame()

func next_frame():
	playing_fade_effect = true
	current_frame += 1
	await Funcs.fade_effect(self)
	
	if current_frame < cinematic_frames.size():
		sprite.texture = cinematic_frames[current_frame].frame
		text_frame.text = cinematic_frames[current_frame].text
	else:
		if not SaveSystem.get_curr_file().cinematics_played.has(id_cinematic):
			SaveSystem.get_curr_file().cinematics_played.append(id_cinematic)
			SaveSystem.save_file()
		Events.change_scene_packed.emit(scene_to_enter)
	
	await Funcs.fade_effect(self, true)
	playing_fade_effect = false
