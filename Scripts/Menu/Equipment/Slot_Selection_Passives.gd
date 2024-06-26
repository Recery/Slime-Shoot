extends TextureButton

# Seleccionar el slot en el que se equipa la pasiva, de 1 a 3
@export var slot = 1

@export var passive_to_equip : PackedScene

func _ready():
	connect("pressed", on_pressed)

func _process(_delta):
	var unlocked = false
	for i in range(Vars.passives_unlocked.size()):
		if Vars.passives_unlocked[i] == passive_to_equip:
			unlocked = true
	
	if !unlocked: 
		get_parent().disabled = true
		get_parent().get_node("Passive").hide()
		get_parent().self_modulate = Color(1,1,1)
		hide()
	else:
		get_parent().disabled = false
		get_parent().get_node("Passive").show()
		get_parent().self_modulate = Color(Color(0, 0.988, 0))
		show()

func on_pressed():
	var already_equipped_slot = -1
	for i in range(Vars.passives_equipped.size()):
		if Vars.passives_equipped[i] == passive_to_equip:
			already_equipped_slot = i
			break
	
	if already_equipped_slot != -1:
		var passive_to_swap = Vars.passives_equipped[slot-1]
		Vars.passives_equipped[slot-1] = passive_to_equip
		Vars.passives_equipped[already_equipped_slot] = passive_to_swap
	else: 
		Vars.passives_equipped[slot-1] = passive_to_equip
	
	Save_System.save_equipped_passives()
