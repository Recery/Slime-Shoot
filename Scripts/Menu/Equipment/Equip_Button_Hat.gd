extends TextureButton

@export var hat_to_equip : PackedScene

@onready var hat_sprite := get_parent().get_node("Hat")
@onready var equipped_hat_pos := get_parent().get_parent().get_parent().get_parent().get_node("Equipped_Hat")

func _ready() -> void:
	Events.draw_equipped_slime.connect(draw_hat)

func _process(_delta) -> void:
	if hat_to_equip == null: return
	var unlocked := false
	for hat in SaveSystem.get_curr_file().save_equipment.unlocked_hats:
		if hat == hat_to_equip:
			unlocked = true
			break
	
	get_parent().disabled = not unlocked
	hat_sprite.visible = unlocked
	visible = unlocked

func _pressed() -> void:
	SaveSystem.get_curr_file().save_equipment.equipped_hat = hat_to_equip
	SaveSystem.save_file()
	Events.equipped_changed.emit()
	Events.draw_equipped_slime.emit()

func draw_hat() -> void:
	Funcs.remove_direct_children(equipped_hat_pos)
	
	equipped_hat_pos.add_child(Funcs.draw_equipped_slime())
