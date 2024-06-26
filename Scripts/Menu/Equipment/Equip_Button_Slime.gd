extends TextureButton

@export var slime_to_equip : PackedScene

var root : Node

func _ready():
	root = get_parent().get_parent().get_parent()
	
	connect("pressed", _on_pressed)
	Events.connect("draw_equipped_slime", draw_slime)

func _process(_delta):
	var unlocked = false
	for i in range(Vars.slimes_unlocked.size()):
		if Vars.slimes_unlocked[i] == slime_to_equip:
			unlocked = true
	
	if !unlocked: 
		get_parent().disabled = true
		get_parent().get_node("Slime").hide()
		get_parent().get_node("Perk").hide()
		hide()
	else:
		get_parent().disabled = false
		get_parent().get_node("Slime").show()
		get_parent().get_node("Perk").show()
		show()

func _on_pressed():
	Vars.slime_equipped = slime_to_equip
	Save_System.save_equipped_slime()
	
	Events.draw_equipped_slime.emit()

func draw_slime():
	Funcs.remove_direct_children(root.get_node("Equipped_Slime"))
	
	var slime_draw := Vars.slime_equipped.instantiate()
	slime_draw.set_script(null)
	root.get_node("Equipped_Slime").add_child(slime_draw)
	
	if Vars.hat_equipped != null:
		var hat_draw := Vars.hat_equipped.instantiate()
		hat_draw.set_script(null)
		root.get_node("Equipped_Slime").add_child(hat_draw)
