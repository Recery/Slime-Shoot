extends Resource
class_name EventInstanceSpawner

@export var scene_to_instance : PackedScene
@export var position_to_spawn : Vector2
@export_node_path("Node") var parent_path
var parent : Node

func init_parent(res_parent : Node):
	parent = res_parent.get_node(parent_path)
