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
	SaveSystem.set_curr_file(slot)
	SaveSystem.save_file()
	
	if disabled:
		enable_file()

@onready var delete_confirmation := get_parent().get_parent().get_parent().get_node("Delete_Confirmation")
func _on_delete_pressed() -> void:
	delete_confirmation.visible = true
	delete_confirmation.get_node("Yes_Button").pressed.connect(delete, CONNECT_ONE_SHOT)
	delete_confirmation.get_node("No_Button").pressed.connect(delete_regret, CONNECT_ONE_SHOT)

func delete() -> void:
	if delete_confirmation.get_node("No_Button").pressed.is_connected(delete_regret):
		delete_confirmation.get_node("No_Button").pressed.disconnect(delete_regret)
	
	SaveSystem.delete_save_file(slot)
	disable_file()
	
	delete_confirmation.visible = false

func delete_regret() -> void:
	if delete_confirmation.get_node("Yes_Button").pressed.is_connected(delete):
		delete_confirmation.get_node("Yes_Button").pressed.disconnect(delete)
	
	delete_confirmation.visible = false