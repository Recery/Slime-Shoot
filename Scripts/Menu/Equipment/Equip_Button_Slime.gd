extends TextureButton

@export var slime_to_equip : PackedScene

@onready var slime_sprite := get_parent().get_node("Slime")
@onready var perk_sprite := get_parent().get_node("Perk")
@onready var equipped_slime_pos := get_parent().get_parent().get_parent().get_node("Equipped_Slime")

func _ready() -> void:
	Events.draw_equipped_slime.connect(draw_slime)

func _process(_delta) -> void:
	var unlocked := false
	for slime in SaveSystem.get_curr_file().save_equipment.unlocked_slimes:
		if slime == slime_to_equip:
			unlocked = true
			break
	
	get_parent().disabled = not unlocked
	slime_sprite.visible = unlocked
	perk_sprite.visible = unlocked
	visible = unlocked

func _pressed() -> void:
	SaveSystem.get_curr_file().save_equipment.equipped_slime = slime_to_equip
	SaveSystem.save_file()
	
	Events.draw_equipped_slime.emit()

func draw_slime() -> void:
	Funcs.remove_direct_children(equipped_slime_pos)
	
	equipped_slime_pos.add_child(Funcs.draw_equipped_slime())
