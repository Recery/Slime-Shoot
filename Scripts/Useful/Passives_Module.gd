extends Node2D

var passives := []

var size_equipped := 0

func _ready():
	var equipped_array := SaveSystem.get_curr_file().save_equipment.equipped_passives
	
	for passive in equipped_array:
		if passive != null: size_equipped += 1
	passives.resize(size_equipped)
	
	var total_equipped := 0
	for passive in equipped_array:
		if passive != null and total_equipped < passives.size():
			passives[total_equipped] = passive.instantiate()
			passives[total_equipped].position = get_node("Pos_" + str(total_equipped+1)).position
			add_child(passives[total_equipped])
			total_equipped += 1
