extends Map

func _ready():
	get_tree().node_added.connect(node_added)
	
	if Vars.slimes_unlocked.has(load("res://Scenes/Player/White_Slime/white_slime.tscn")):
		get_node("Elements/Cagged_White_Slime").queue_free()
		get_node("Events/Create_Ladder_Desert_Mother").activation_signal_emitted()

func node_added(node : Node):
	if node.is_in_group("Ladder"):
		node.map_to_enter = "res://Scenes/Maps/desert_level.tscn"
		node.up = true
