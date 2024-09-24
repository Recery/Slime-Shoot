extends TextureButton

# Seleccionar el slot en el que se equipa la habilidad, de 1 a 3
@export var slot = 1

@export var ability_to_equip : PackedScene

@onready var ability_sprite := get_parent().get_node("Ability")

func _process(_delta) -> void:
	var unlocked := false
	for ability in SaveSystem.get_curr_file().save_equipment.unlocked_abilities:
		if ability == ability_to_equip:
			unlocked = true
			break
	
	get_parent().disabled = not unlocked
	ability_sprite.visible = unlocked
	visible = unlocked

func _pressed() -> void:
	var equipped_array := SaveSystem.get_curr_file().save_equipment.equipped_abilities
	var already_equipped_slot = -1
	for i in range(equipped_array.size()):
		if equipped_array[i] == ability_to_equip:
			already_equipped_slot = i
			break
	
	if already_equipped_slot != -1:
		var ability_to_swap = equipped_array[slot-1]
		equipped_array[slot-1] = ability_to_equip
		equipped_array[already_equipped_slot] = ability_to_swap
	else: 
		equipped_array[slot-1] = ability_to_equip
	
	SaveSystem.save_file()
