extends TextureButton

# Seleccionar el slot en el que se equipa la pasiva, de 1 a 3
@export var slot = 1

@export var passive_to_equip : PackedScene

@onready var passive_sprite := get_parent().get_node("Passive")

func _process(_delta) -> void:
	var unlocked := false
	for passive in SaveSystem.get_curr_file().save_equipment.unlocked_passives:
		if passive == passive_to_equip:
			unlocked = true
			break
	
	get_parent().disabled = not unlocked
	passive_sprite.visible = unlocked
	visible = unlocked
	
	if unlocked: get_parent().self_modulate = Color(0, 0.988, 0)
	else: get_parent().self_modulate = Color(Color(1,1,1))

func _pressed() -> void:
	var equipped_array := SaveSystem.get_curr_file().save_equipment.equipped_passives
	var already_equipped_slot = -1
	for i in range(equipped_array.size()):
		if equipped_array[i] == passive_to_equip:
			already_equipped_slot = i
			break
	
	if already_equipped_slot != -1:
		var passive_to_swap = equipped_array[slot-1]
		equipped_array[slot-1] = passive_to_equip
		equipped_array[already_equipped_slot] = passive_to_swap
	else: 
		equipped_array[slot-1] = passive_to_equip
	
	SaveSystem.save_file()
	Events.equipped_changed.emit()
