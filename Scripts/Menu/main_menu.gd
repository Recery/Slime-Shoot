extends Control

@onready var buttons = get_node("Main_Buttons")
@onready var equipment_buttons = get_node("Equipment_Buttons")
@onready var support_buttons = get_node("Support_Buttons")
@onready var other_buttons = get_node("Other_Buttons")
@onready var title = get_node("Title")
@onready var map_selection = get_node("Map_Selection")
@onready var controls = get_node("Controls")
@onready var credits = get_node("Credits")
@onready var equipment_slimes = get_node("Equipment_Slimes")
@onready var equipment_weapons = get_node("Equipment_Weapons")
@onready var equipment_abilities = get_node("Equipment_Abilities")
@onready var equipment_passives = get_node("Equipment_Passives")
@onready var equipment_hats = get_node("Equipment_Hats")
@onready var equipment_pets = get_node("Equipment_Pets")
@onready var shop = get_node("Shop")
@onready var settings = get_node("Settings")
@onready var save_selector := get_node("Save_Selector")
@onready var cinematics = get_node("Replay_Cinematics")
@onready var enemy_almanac = get_node("Enemy_Almanac")
@onready var back_button = get_node("BackButton")

func _ready() -> void:
	Events.draw_equipped_slime.connect(draw_slime)
	Events.draw_equipped_slime.emit()
	
	get_node("Title/Version").text = "v" + ProjectSettings.get_setting("application/config/version")
	set_menu_theme()

@onready var slime_pos := get_node("Slime")
@onready var pet_pos := get_node("Pet")
func draw_slime() -> void:
	# Dibujar slime
	Funcs.remove_direct_children(slime_pos)
	slime_pos.add_child(Funcs.draw_equipped_slime())
	
	# Dibujar mascota
	Funcs.remove_direct_children(pet_pos)
	var pet_draw := Funcs.draw_pet()
	if pet_draw != null:
		pet_pos.add_child(pet_draw)

func set_menu_theme() -> void:
	var background_pos := get_node("Background")
	match Vars.menu_map_photo:
		Vars.menu_maps.GRASSLANDS: background_pos.add_child(load("res://Scenes/Menu/Map_Images/grasslands_menu.tscn").instantiate())
		Vars.menu_maps.DESERT: background_pos.add_child(load("res://Scenes/Menu/Map_Images/desert.tscn").instantiate())
		Vars.menu_maps.SNOW: background_pos.add_child(load("res://Scenes/Menu/Map_Images/snow_menu.tscn").instantiate())
		Vars.menu_maps.CYBERSPACE: background_pos.add_child(load("res://Scenes/Menu/Map_Images/cyber_menu.tscn").instantiate())
		_: background_pos.add_child(load("res://Scenes/Menu/Map_Images/grasslands_menu.tscn").instantiate())

# Botón start
func _on_start_pressed() -> void:
	buttons.hide()
	equipment_buttons.hide()
	support_buttons.hide()
	other_buttons.hide()
	title.hide()
	map_selection.show()
	back_button.show()
	Funcs.sound_play("res://Sounds/uiclick.mp3", 20)
# Fin botón start

# Botón controles
func _on_controls_pressed() -> void:
	buttons.hide()
	equipment_buttons.hide()
	support_buttons.hide()
	other_buttons.hide()
	title.hide()
	controls.show()
	back_button.show()
	Funcs.sound_play("res://Sounds/uiclick.mp3", 20)
# Fin botón controles

# Botón créditos
func _on_credits_pressed() -> void:
	buttons.hide()
	equipment_buttons.hide()
	support_buttons.hide()
	other_buttons.hide()
	title.hide()
	credits.show()
	back_button.show()
	Funcs.sound_play("res://Sounds/uiclick.mp3", 20)
# Fin botón créditos

# Botón salir
func _on_quit_pressed() -> void:
	Funcs.sound_play("res://Sounds/uiclick.mp3", 20)
	get_tree().quit()
# Fin botón salir

# Botón slimes
func _on_slimes_pressed() -> void:
	buttons.hide()
	equipment_buttons.hide()
	support_buttons.hide()
	other_buttons.hide()
	title.hide()
	equipment_slimes.show()
	back_button.show()
	Funcs.sound_play("res://Sounds/uiclick.mp3", 20)
# Fin botón slimes

# Botón armas
func _on_weapons_pressed() -> void:
	buttons.hide()
	equipment_buttons.hide()
	support_buttons.hide()
	other_buttons.hide()
	title.hide()
	equipment_weapons.show()
	back_button.show()
	Funcs.sound_play("res://Sounds/uiclick.mp3", 20)
# Fin botón armas

# Botón habilidades
func _on_abilities_pressed() -> void:
	buttons.hide()
	equipment_buttons.hide()
	support_buttons.hide()
	other_buttons.hide()
	title.hide()
	equipment_abilities.show()
	back_button.show()
	Funcs.sound_play("res://Sounds/uiclick.mp3", 20)
# Fin botón habilidades

# Botón pasivas
func _on_passives_pressed() -> void:
	buttons.hide()
	equipment_buttons.hide()
	support_buttons.hide()
	other_buttons.hide()
	title.hide()
	equipment_passives.show()
	back_button.show()
	Funcs.sound_play("res://Sounds/uiclick.mp3", 20)
# Fin botón pasivas

# Botón sombreros
func _on_hats_pressed() -> void:
	buttons.hide()
	equipment_buttons.hide()
	support_buttons.hide()
	other_buttons.hide()
	title.hide()
	equipment_hats.show()
	back_button.show()
	Funcs.sound_play("res://Sounds/uiclick.mp3", 20)
# Fin botón sombreros

# Botón mascotas
func _on_pets_pressed() -> void:
	buttons.hide()
	equipment_buttons.hide()
	support_buttons.hide()
	other_buttons.hide()
	title.hide()
	equipment_pets.show()
	back_button.show()
	Funcs.sound_play("res://Sounds/uiclick.mp3", 20)

# Fin botón mascotas
# Botón tienda
func _on_shop_pressed() -> void:
	buttons.hide()
	equipment_buttons.hide()
	support_buttons.hide()
	other_buttons.hide()
	title.hide()
	shop.show()
	back_button.show()
	Funcs.sound_play("res://Sounds/uiclick.mp3", 20)
# Fin botón tienda

# Botón ajustes
func _on_settings_button_pressed() -> void:
	buttons.hide()
	equipment_buttons.hide()
	support_buttons.hide()
	other_buttons.hide()
	title.hide()
	settings.show()
	back_button.show()
	Funcs.sound_play("res://Sounds/uiclick.mp3", 20)
# Fin botón ajustes

# Botón guardado
func _on_save_button_pressed() -> void:
	buttons.hide()
	equipment_buttons.hide()
	support_buttons.hide()
	other_buttons.hide()
	title.hide()
	save_selector.show()
	back_button.show()
	Funcs.sound_play("res://Sounds/uiclick.mp3", 20)
# Fin botón guardado

# Botón cinemáticas
func _on_cinematics_button_pressed() -> void:
	buttons.hide()
	equipment_buttons.hide()
	support_buttons.hide()
	other_buttons.hide()
	title.hide()
	cinematics.show()
	back_button.show()
	Funcs.sound_play("res://Sounds/uiclick.mp3", 20)
# Fin botón cinemáticas

func _on_enemy_almanac_button_pressed() -> void:
	buttons.hide()
	equipment_buttons.hide()
	support_buttons.hide()
	other_buttons.hide()
	title.hide()
	enemy_almanac.show()
	back_button.show()
	Funcs.sound_play("res://Sounds/uiclick.mp3", 20)

# Botón atrás
func _on_back_button_pressed() -> void:
	hide_all()
	Funcs.sound_play("res://Sounds/uiclick.mp3", 20)
# Fin botón atrás

func hide_all() -> void:
	buttons.show()
	equipment_buttons.show()
	support_buttons.show()
	other_buttons.show()
	title.show()
	map_selection.hide()
	controls.hide()
	credits.hide()
	equipment_slimes.hide()
	equipment_weapons.hide()
	equipment_abilities.hide()
	equipment_passives.hide()
	equipment_hats.hide()
	equipment_pets.hide()
	shop.hide()
	settings.hide()
	save_selector.hide()
	cinematics.hide()
	enemy_almanac.hide()
	back_button.hide()
