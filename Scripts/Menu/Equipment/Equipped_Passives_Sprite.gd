extends Sprite2D

func _ready() -> void:
	draw_passives()
	Events.equipped_changed.connect(draw_passives)
	Events.save_file_changed.connect(draw_passives)

func draw_passives() -> void:
	var equipped_array := SaveSystem.get_curr_file().save_equipment.equipped_passives
	for i in range(equipped_array.size()):
		var pos = get_node("Pos_" + str(i+1))
		if pos.get_child_count() != 0: Funcs.remove_children(pos)
		if equipped_array[i] != null:
			var sprite = equipped_array[i].instantiate()
			sprite.set_script(false)
			pos.add_child(sprite)
