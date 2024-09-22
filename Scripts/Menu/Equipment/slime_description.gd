extends Control
class_name SlimeDescription

@onready var life_label := get_node("Life/Amount") as Label
@onready var max_energy_label := get_node("Max_Energy/Amount") as Label
@onready var speed_label := get_node("Speed/Amount") as Label
@onready var resistance_label := get_node("Resistance/Amount") as Label
@onready var description_label := get_node("Description_Scroll/Description") as Label
@onready var texture_rect := get_node("Slime") as TextureRect

@onready var perk_rect := get_node("Perk") as TextureRect
@onready var perk_cooldown_label := get_node("Cooldown/Amount") as Label
@onready var perk_energy_label := get_node("Energy_Use/Amount") as Label

func _on_back_button_pressed() -> void:
	Funcs.sound_play("res://Sounds/uiclick.mp3", 20)
	queue_free()

func set_info(new_info : SlimeInfo) -> void:
	life_label.text = new_info.life
	max_energy_label.text = new_info.max_energy
	speed_label.text = new_info.speed
	resistance_label.text = new_info.resistance
	description_label.text = new_info.description
	texture_rect.texture = new_info.texture
	
	perk_rect.texture = new_info.perk_texture
	perk_cooldown_label.text = new_info.perk_cooldown
	perk_energy_label.text = new_info.perk_energy_use
