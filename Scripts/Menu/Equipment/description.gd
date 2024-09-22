extends Control
class_name Description

@onready var description_label := get_node("Description_Scroll/Description") as Label
@onready var cooldown_label := get_node("Cooldown/Amount") as Label
@onready var energy_label := get_node("Energy_Use/Amount") as Label
@onready var texture_rect := get_node("Item") as TextureRect

func _on_back_button_pressed() -> void:
	Funcs.sound_play("res://Sounds/uiclick.mp3", 20)
	queue_free()

func set_info(new_info : ItemInfo) -> void:
	if new_info is UsableItemInfo:
		cooldown_label.text = new_info.cooldown
		energy_label.text = new_info.energy_use
	else:
		cooldown_label.get_parent().visible = false
		energy_label.get_parent().visible = false
	description_label.text = new_info.description
	texture_rect.texture = new_info.texture
