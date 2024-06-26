extends Resource
## Contiene un nodo y la señal que envia
class_name NodeAndSignal

@export_node_path("Node") var emitter_node_path
var emitter_node : Node
@export var signal_name : String
var activated := false

func init_node(parent : Node) -> void:
	emitter_node = parent.get_node(emitter_node_path)
