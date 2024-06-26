extends TextureButton

@export var hat_to_equip : PackedScene

var root

func _ready():
	root = get_parent().get_parent().get_parent().get_parent()
	
	Events.connect("draw_equipped_slime", draw_hat)
	connect("pressed", _on_pressed)

func _process(_delta):
	if hat_to_equip == null: return
	var unlocked = false
	for i in range(Vars.hats_unlocked.size()):
		if Vars.hats_unlocked[i] == hat_to_equip:
			unlocked = true
	
	get_parent().get_node("Hat").visible = unlocked
	get_parent().disabled = not unlocked
	visible = unlocked

func _on_pressed():
	Vars.hat_equipped = hat_to_equip
	
	Save_System.save_equipped_hat()
	
	Events.draw_equipped_slime.emit()

func draw_hat():
	Funcs.remove_direct_children(root.get_node("Equipped_Hat"))
	
	var slime_draw := Vars.slime_equipped.instantiate()
	slime_draw.set_script(null)
	root.get_node("Equipped_Hat").add_child(slime_draw)
	
	if Vars.hat_equipped != null:
		var hat_draw := Vars.hat_equipped.instantiate()
		hat_draw.set_script(null)
		root.get_node("Equipped_Hat").add_child(hat_draw)
