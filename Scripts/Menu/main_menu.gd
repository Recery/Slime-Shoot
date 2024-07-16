extends Control

var buttons
var equipment_buttons
var other_buttons
var title
var map_selection
var controls
var credits
var equipment_slimes
var equipment_weapons
var equipment_abilities
var equipment_passives
var equipment_hats
var equipment_pets
var shop
var settings
var cinematics
var back_button

func _ready():
	buttons = get_node("Main_Buttons")
	equipment_buttons = get_node("Equipment_Buttons")
	other_buttons = get_node("Other_Buttons")
	title = get_node("Title")
	map_selection = get_node("Map_Selection")
	controls = get_node("Controls")
	credits = get_node("Credits")
	
	equipment_buttons = get_node("Equipment_Buttons")
	equipment_slimes = get_node("Equipment_Slimes")
	equipment_weapons = get_node("Equipment_Weapons")
	equipment_abilities = get_node("Equipment_Abilities")
	equipment_passives = get_node("Equipment_Passives")
	equipment_hats = get_node("Equipment_Hats")
	equipment_pets = get_node("Equipment_Pets")
	shop = get_node("Shop")
	settings = get_node("Settings")
	cinematics = get_node("Replay_Cinematics")
	
	back_button = get_node("BackButton")
	
	Events.connect("draw_equipped_slime", draw_slime)
	Events.draw_equipped_slime.emit()

func draw_slime():
	Funcs.remove_direct_children(get_node("Slime"))
	
	var slime_draw := Vars.slime_equipped.instantiate()
	slime_draw.set_script(null)
	get_node("Slime").add_child(slime_draw)
	
	if Vars.hat_equipped != null:
		var hat_draw := Vars.hat_equipped.instantiate()
		hat_draw.set_script(null)
		get_node("Slime").add_child(hat_draw)

# Botón start
func _on_start_pressed():
	buttons.hide()
	equipment_buttons.hide()
	other_buttons.hide()
	title.hide()
	map_selection.show()
	back_button.show()
	Funcs.sound_play("res://Sounds/uiclick.mp3", 20)
# Fin botón start

# Botón controles
func _on_controls_pressed():
	buttons.hide()
	equipment_buttons.hide()
	other_buttons.hide()
	title.hide()
	controls.show()
	back_button.show()
	Funcs.sound_play("res://Sounds/uiclick.mp3", 20)
# Fin botón controles

# Botón créditos
func _on_credits_pressed():
	buttons.hide()
	equipment_buttons.hide()
	other_buttons.hide()
	title.hide()
	credits.show()
	back_button.show()
	Funcs.sound_play("res://Sounds/uiclick.mp3", 20)
# Fin botón créditos

# Botón salir
func _on_quit_pressed():
	Funcs.sound_play("res://Sounds/uiclick.mp3", 20)
	get_tree().quit()
# Fin botón salir

# Botón slimes
func _on_slimes_pressed():
	buttons.hide()
	equipment_buttons.hide()
	other_buttons.hide()
	title.hide()
	equipment_slimes.show()
	back_button.show()
	Funcs.sound_play("res://Sounds/uiclick.mp3", 20)
# Fin botón slimes

# Botón armas
func _on_weapons_pressed():
	buttons.hide()
	equipment_buttons.hide()
	other_buttons.hide()
	title.hide()
	equipment_weapons.show()
	back_button.show()
	Funcs.sound_play("res://Sounds/uiclick.mp3", 20)
# Fin botón armas

# Botón habilidades
func _on_abilities_pressed():
	buttons.hide()
	equipment_buttons.hide()
	other_buttons.hide()
	title.hide()
	equipment_abilities.show()
	back_button.show()
	Funcs.sound_play("res://Sounds/uiclick.mp3", 20)
# Fin botón habilidades

# Botón pasivas
func _on_passives_pressed():
	buttons.hide()
	equipment_buttons.hide()
	other_buttons.hide()
	title.hide()
	equipment_passives.show()
	back_button.show()
	Funcs.sound_play("res://Sounds/uiclick.mp3", 20)
# Fin botón pasivas

# Botón sombreros
func _on_hats_pressed():
	buttons.hide()
	equipment_buttons.hide()
	other_buttons.hide()
	title.hide()
	equipment_hats.show()
	back_button.show()
	Funcs.sound_play("res://Sounds/uiclick.mp3", 20)
# Fin botón sombreros

# Botón mascotas
func _on_pets_pressed():
	buttons.hide()
	equipment_buttons.hide()
	other_buttons.hide()
	title.hide()
	equipment_pets.show()
	back_button.show()
	Funcs.sound_play("res://Sounds/uiclick.mp3", 20)

# Fin botón mascotas
# Botón tienda
func _on_shop_pressed():
	buttons.hide()
	equipment_buttons.hide()
	other_buttons.hide()
	title.hide()
	shop.show()
	back_button.show()
	Funcs.sound_play("res://Sounds/uiclick.mp3", 20)
# Fin botón tienda

# Botón ajustes
func _on_settings_button_pressed():
	buttons.hide()
	equipment_buttons.hide()
	other_buttons.hide()
	title.hide()
	settings.show()
	back_button.show()
	Funcs.sound_play("res://Sounds/uiclick.mp3", 20)
# Fin botón ajustes

# Botón cinemáticas
func _on_cinematics_button_pressed():
	buttons.hide()
	equipment_buttons.hide()
	other_buttons.hide()
	title.hide()
	cinematics.show()
	back_button.show()
	Funcs.sound_play("res://Sounds/uiclick.mp3", 20)
# Fin botón cinemáticas



# Botón atrás
func _on_back_button_pressed():
	hide_all()
	Funcs.sound_play("res://Sounds/uiclick.mp3", 20)
# Fin botón atrás

func hide_all():
	buttons.show()
	equipment_buttons.show()
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
	cinematics.hide()
	back_button.hide()
