extends TextureButton

# Seleccionar el slot en el que se equipa el arma, de 1 a 3
@export var slot = 1

@export var weapon_to_equip : PackedScene

@onready var weapon_sprite := get_parent().get_node("Weapon")

func _process(_delta) -> void:
	var unlocked := false
	for weapon in SaveSystem.get_curr_file().save_equipment.unlocked_weapons:
		if weapon == weapon_to_equip:
			unlocked = true
			break
	
	get_parent().disabled = not unlocked
	weapon_sprite.visible = unlocked
	visible = unlocked

func _pressed() -> void:
	var equipped_array := SaveSystem.get_curr_file().save_equipment.equipped_weapons
	var already_equipped_slot = -1
	for i in range(equipped_array.size()):
		if equipped_array[i] == weapon_to_equip:
			already_equipped_slot = i
			break
	
	if already_equipped_slot != -1:
		var weapon_to_swap = equipped_array[slot-1]
		equipped_array[slot-1] = weapon_to_equip
		equipped_array[already_equipped_slot] = weapon_to_swap
	else: 
		equipped_array[slot-1] = weapon_to_equip
	
	SaveSystem.save_file()
