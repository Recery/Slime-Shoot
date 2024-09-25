extends TextureButton

@export var pet_to_equip : PackedScene

@onready var pet_sprite := get_parent().get_node("Pet")
@onready var pet_pos := get_parent().get_parent().get_parent().get_parent().get_node("Equipped_Pet")

func _ready() -> void: Events.draw_equipped_slime.connect(draw_pet)

func _process(_delta) -> void:
	if pet_to_equip == null: return
	var unlocked := false
	for pet in SaveSystem.get_curr_file().save_equipment.unlocked_pets:
		if pet == pet_to_equip:
			unlocked = true
			break
	
	get_parent().disabled = not unlocked
	pet_sprite.visible = unlocked
	visible = unlocked

func _pressed() -> void:
	SaveSystem.get_curr_file().save_equipment.equipped_pet = pet_to_equip
	SaveSystem.save_file()
	Events.equipped_changed.emit()
	Events.draw_equipped_slime.emit()

func draw_pet() -> void:
	Funcs.remove_direct_children(pet_pos)
	var pet_draw := Funcs.draw_pet()
	if pet_draw != null:
		pet_pos.add_child(pet_draw)
