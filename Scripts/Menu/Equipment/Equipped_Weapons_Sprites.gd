extends Node2D

func _ready() -> void:
	draw_weapons()

func _process(_delta) -> void:
	draw_weapons()

func draw_weapons() -> void:
	var equipped_array := SaveSystem.get_curr_file().save_equipment.equipped_weapons
	for i in range(equipped_array.size()):
		var pos = get_node("Pos_" + str(i+1))
		if pos.get_child_count() != 0: Funcs.remove_children(pos)
		if equipped_array[i] != null:
			var sprite = equipped_array[i].instantiate()
			sprite.set_script(false)
			if sprite.has_node("Frame_Sprite"):
				var parent = sprite
				sprite = parent.get_node("Frame_Sprite").duplicate()
				parent.queue_free()
			pos.add_child(sprite)
			sprite.position = Vector2.ZERO
			sprite.visible = true
