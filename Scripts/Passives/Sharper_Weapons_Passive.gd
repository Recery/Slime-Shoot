extends Node2D

func _ready():
	get_tree().node_added.connect(node_entered)

func node_entered(node):
	if not node.is_in_group("Friendly_Damage"): return
	if "enemies_damaged" not in node: return
	if not node.is_node_ready(): await node.ready
	node.enemies_damaged -= 1
