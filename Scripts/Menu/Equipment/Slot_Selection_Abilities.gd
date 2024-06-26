extends TextureButton

# Seleccionar el slot en el que se equipa la habilidad, de 1 a 3
@export var slot = 1

@export var ability_to_equip : PackedScene

func _ready():
	connect("pressed", on_pressed)

func _process(_delta):
	var unlocked = false
	for i in range(Vars.abilities_unlocked.size()):
		if Vars.abilities_unlocked[i] == ability_to_equip:
			unlocked = true
	if !unlocked: 
		get_parent().disabled = true
		get_parent().get_node("Ability").hide()
		hide()
	else:
		get_parent().disabled = false
		get_parent().get_node("Ability").show()
		show()

func on_pressed():
	var already_equipped_slot = -1
	for i in range(Vars.abilities_equipped.size()):
		if Vars.abilities_equipped[i] == ability_to_equip:
			already_equipped_slot = i
			break
	
	if already_equipped_slot != -1:
		var ability_to_swap = Vars.abilities_equipped[slot-1]
		Vars.abilities_equipped[slot-1] = ability_to_equip
		Vars.abilities_equipped[already_equipped_slot] = ability_to_swap
	else: 
		Vars.abilities_equipped[slot-1] = ability_to_equip
	
	Save_System.save_equipped_abilities()
