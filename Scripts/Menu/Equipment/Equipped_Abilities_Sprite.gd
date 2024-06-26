extends Sprite2D

func _ready():
	draw_abilities()

func _process(_delta):
	draw_abilities()

func draw_abilities():
	for i in range(Vars.abilities_equipped.size()):
		var pos = get_node("Pos_" + str(i+1))
		if pos.get_child_count() != 0: Funcs.remove_children(pos)
		if Vars.abilities_equipped[i] != null:
			var sprite = Vars.abilities_equipped[i].instantiate()
			sprite.set_script(false)
			pos.add_child(sprite)
