extends Map

func _ready():
	get_tree().node_added.connect(node_added)
	
	if Vars.slimes_unlocked.has(load("res://Scenes/Player/Yellow_Slime/yellow_slime.tscn")):
		get_node("Cagged_Yellow_Slime").queue_free()
		get_node("Events/Spawn_Ladder").activation_signal_emitted()

func node_added(node : Node):
	if node.is_in_group("Ladder"):
		node.map_to_enter = "res://Scenes/Maps/Grasslands_Level.tscn"
		node.up = true
