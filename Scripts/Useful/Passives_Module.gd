extends Node2D

var passives = []

var size_equipped

func _ready():
	size_equipped = 0
	for i in range(Vars.passives_equipped.size()):
		if Vars.passives_equipped[i] != null: size_equipped += 1
	passives.resize(size_equipped)
	
	var total_equipped = 0
	for i in range(Vars.passives_equipped.size()):
		if Vars.passives_equipped[i] != null && total_equipped < passives.size():
			passives[total_equipped] = Vars.passives_equipped[i].instantiate()
			passives[total_equipped].position = get_node("Pos_" + str(i+1)).position
			add_child(passives[total_equipped])
			total_equipped += 1
