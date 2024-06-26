extends Sprite2D

func _ready():
	draw_passives()

func _process(_delta):
	draw_passives()

func draw_passives():
	for i in range(Vars.passives_equipped.size()):
		var pos = get_node("Pos_" + str(i+1))
		if pos.get_child_count() != 0: Funcs.remove_children(pos)
		if Vars.passives_equipped[i] != null:
			var sprite = Vars.passives_equipped[i].instantiate()
			sprite.set_script(false)
			pos.add_child(sprite)
