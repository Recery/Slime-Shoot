@tool
extends Area2D

## Si el nodo se libera luego de activarse.
@export var queue_free_after := true
## Si en lugar de activarse por colisión se activa por señal.
## El método que se ejecuta con la señal deseada se llama "activation_signal_emitted".
@export var activate_by_signal := false
@export_group("Emit signals")
## Las escenas cuyas señales se emiten. 
@export var nodes_to_connect : Array[NodeAndSignal]

@export_group("Instance")
@export var scene_instancer : Array[EventInstanceSpawner]

func _ready() -> void:
	if activate_by_signal:
		monitoring = false

func _process(_delta) -> void:
	if not Engine.is_editor_hint(): 
		set_process(false)
		return
	
	## IMPORTANTE SACAR ESTE PEDAZO DE CÓDIGO CADA VEZ QUE SE EXPORTA EL JUEGO
	#if not EditorInterface.get_selection().get_selected_nodes().has(self):
	#	return
	
	if Input.is_action_just_pressed("ui_text_completion_query"):
		var new_instance = EventInstanceSpawner.new()
		scene_instancer.append(new_instance)
		new_instance.position_to_spawn = get_node("Instance_Position").global_position

func _on_body_entered(body) -> void:
	if body == Vars.player:
		activate()

func emit_signals() -> void:
	for node_res in nodes_to_connect:
		node_res.init_node(self)
		node_res.emitter_node.emit_signal(node_res.signal_name)

func instance_scene() -> void:
	for scene_res in scene_instancer:
		var instance = scene_res.scene_to_instance.instantiate()
		scene_res.init_parent(self)
		scene_res.parent.call_deferred("add_child", instance)
		if not instance.is_node_ready(): await instance.tree_entered
		instance.global_position = scene_res.position_to_spawn

func activation_signal_emitted(_arg1=1, _arg2=2) -> void:
	activate()

func activate() -> void:
	emit_signals()
	instance_scene()
	if queue_free_after: queue_free()
