extends Sprite2D

func _ready():
	draw_weapons()

func _process(_delta):
	draw_weapons()

func draw_weapons():
	for i in range(Vars.weapons_equipped.size()):
		var pos = get_node("Pos_" + str(i+1))
		if pos.get_child_count() != 0: Funcs.remove_children(pos)
		if Vars.weapons_equipped[i] != null:
			var sprite = Vars.weapons_equipped[i].instantiate()
			sprite.set_script(false)
			if sprite.has_node("Frame_Sprite"):
				var parent = sprite
				sprite = parent.get_node("Frame_Sprite").duplicate()
				parent.queue_free()
			pos.add_child(sprite)
			sprite.position = Vector2.ZERO
			sprite.visible = true
