extends TextureButton

# Seleccionar el slot en el que se equipa el arma, de 1 a 3
@export var slot = 1

@export var weapon_to_equip : PackedScene

func _ready():
	connect("pressed", on_pressed)

func _process(_delta):
	var unlocked = false
	for i in range(Vars.weapons_unlocked.size()):
		if Vars.weapons_unlocked[i] == weapon_to_equip:
			unlocked = true
	if !unlocked:
		get_parent().disabled = true
		get_parent().get_node("Weapon").hide()
		hide()
	else:
		get_parent().disabled = false
		get_parent().get_node("Weapon").show()
		show()

func on_pressed():
	var already_equipped_slot = -1
	for i in range(Vars.weapons_equipped.size()):
		if Vars.weapons_equipped[i] == weapon_to_equip:
			already_equipped_slot = i
			break
	
	if already_equipped_slot != -1:
		var weapon_to_swap = Vars.weapons_equipped[slot-1]
		Vars.weapons_equipped[slot-1] = weapon_to_equip
		Vars.weapons_equipped[already_equipped_slot] = weapon_to_swap
	else: 
		Vars.weapons_equipped[slot-1] = weapon_to_equip
	
	Save_System.save_equipped_weapons()
