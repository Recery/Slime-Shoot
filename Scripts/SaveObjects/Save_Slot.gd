extends Control

@export var slot : int = 0

@onready var points_label := get_node("Points/Points") as Label
@onready var slime_pos := get_node("Slime") as Node2D

var disabled := false
func _ready() -> void:
	get_node("Slot").text = "S" + str(slot+1)
	Events.draw_equipped_slime.connect(draw_slime)
	
	if not SaveSystem.get_save_file(slot).saved:
		disable_file()

func disable_file() -> void:
	disabled = true
	get_node("Buttons/Load/Icon").texture = load("res://Sprites/Menu/Saves/NewSavelIcon.png")
	get_node("Buttons/Load").visible = true
	get_node("Buttons/Delete").visible = false
	get_node("Frame").self_modulate = Color.html("#7a7a7a")
	get_node("Points").visible = false
	slime_pos.visible = false

func enable_file() -> void:
	disabled = false
	get_node("Buttons/Load/Icon").texture = load("res://Sprites/Menu/Saves/LoadSavelIcon.png")
	get_node("Buttons/Load").visible = true
	get_node("Buttons/Delete").visible = true
	get_node("Frame").self_modulate = Color(1,1,1)
	get_node("Points").visible = true
	slime_pos.visible = true

func set_active(active : bool) -> void:
	if disabled: return
	
	get_node("Buttons/Load").visible = not active
	get_node("Buttons/Delete").visible = not active
	if active: get_node("Frame").self_modulate = Color.html("#7a7a7a")
	else: get_node("Frame").self_modulate = Color(1,1,1)

func _process(_delta: float) -> void:
	points_label.text = str(SaveSystem.get_save_file(slot).points)
	set_active(SaveSystem.curr_slot == slot)

func draw_slime() -> void:
	Funcs.remove_direct_children(slime_pos)
	var slime_draw := Funcs.draw_equipped_slime(true, Vector2.ONE, SaveSystem.get_save_file(slot))
	if slime_draw == null: return
	
	slime_pos.add_child(slime_draw)

func _on_load_pressed() -> void:
	if disabled:
		enable_file()
	else:
		# Solo seleccionar como slot actual si el archivo no acaba de ser creado
		SaveSystem.set_curr_file(slot)
	
	SaveSystem.save_file(slot)

var delete_confirmation := preload("res://Scenes/Menu/save_delete_confirmation.tscn")
var curr_delete_confirmation : Control
func _on_delete_pressed() -> void:
	curr_delete_confirmation = delete_confirmation.instantiate()
	Vars.main_scene.add_child(curr_delete_confirmation)
	
	curr_delete_confirmation.get_node("Yes_Button").pressed.connect(delete, CONNECT_ONE_SHOT)
	curr_delete_confirmation.get_node("No_Button").pressed.connect(delete_regret, CONNECT_ONE_SHOT)

func delete() -> void:
	if curr_delete_confirmation == null: return
	
	SaveSystem.delete_save_file(slot)
	disable_file()
	
	curr_delete_confirmation.queue_free()

func delete_regret() -> void:
	if curr_delete_confirmation == null: return
	
	curr_delete_confirmation.queue_free()
