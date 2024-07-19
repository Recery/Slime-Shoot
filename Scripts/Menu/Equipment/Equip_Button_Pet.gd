extends TextureButton

@export var pet_to_equip : PackedScene

var root

func _ready():
	root = get_parent().get_parent().get_parent().get_parent()
	
	Events.connect("draw_equipped_slime", draw_pet)
	connect("pressed", _on_pressed)

func _process(_delta):
	if pet_to_equip == null: return
	var unlocked = false
	for i in range(Vars.pets_unlocked.size()):
		if Vars.pets_unlocked[i] == pet_to_equip:
			unlocked = true
	
	get_parent().get_node("Pet").visible = unlocked
	get_parent().disabled = not unlocked
	visible = unlocked

func _on_pressed():
	Vars.pet_equipped = pet_to_equip
	draw_pet()
	
	Events.draw_equipped_slime.emit()
	
	Save_System.save_equipped_pet()

func draw_pet():
	Funcs.remove_direct_children(root.get_node("Equipped_Pet"))
	if Vars.pet_equipped != null:
		var pet_draw = Vars.pet_equipped.instantiate()
		pet_draw.set_script(null)
		root.get_node("Equipped_Pet").add_child(pet_draw)
