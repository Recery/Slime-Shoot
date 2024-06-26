extends Area2D

@export var boss_spawn : EventInstanceSpawner

## Cuando muera el boss, todos los nodos asignados en
## este array van a emitir la señal designada.
@export var nodes_connected : Array[NodeAndSignal]

func _on_body_entered(body) -> void:
	if body == Vars.player:
		set_deferred("monitoring", false)
		add_boss()

func add_boss() -> void:
	var boss_instance = boss_spawn.scene_to_instance.instantiate()
	boss_spawn.init_parent(self)
	boss_spawn.parent.call_deferred("add_child", boss_instance)
	if not boss_instance.is_node_ready(): await boss_instance.tree_entered
	boss_instance.global_position = boss_spawn.position_to_spawn
	boss_instance.connect("die", _on_boss_die)
	for node in nodes_connected:
		node.init_node(self)

var emitted := false
func _on_boss_die() -> void:
	if emitted: return
	emitted = true
	
	for node in nodes_connected:
		node.emitter_node.emit_signal(node.signal_name)
	
	for child in Funcs.get_all_children(Vars.main_scene):
		if child.is_in_group("Enemy_Spawner"): child.queue_free()
	
	queue_free()
