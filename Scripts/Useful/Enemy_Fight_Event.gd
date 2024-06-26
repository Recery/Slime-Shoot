extends Area2D

@export var enemies_to_spawn : Array[EventInstanceSpawner]

## Cuando muera el boss, todos los nodos asignados en
## este array van a emitir la señal designada.
@export var nodes_connected : Array[NodeAndSignal]

@export var dungeon_mode := false
@onready var music_to_play : = get_node("Music_To_Play")

func _on_body_entered(body) -> void:
	if body == Vars.player:
		set_deferred("monitoring", false)
		spawn_enemies()

func spawn_enemies() -> void:
	for enemy in enemies_to_spawn:
		var enemy_instance = enemy.scene_to_instance.instantiate()
		enemy_instance.add_to_group("Cant_Despawn")
		enemy_instance.wait_player_mode = dungeon_mode # Se pone el wait_player_mode para subir estadisticas si asi se desea
		enemy.init_parent(self)
		enemy.parent.call_deferred("add_child", enemy_instance)
		if not enemy_instance.is_node_ready(): await enemy_instance.tree_entered
		enemy_instance.global_position = enemy.position_to_spawn
		enemy_instance.waiting_player = false # waiting_player se pone en false ya que no se busca que el enemy espere al jugador
		enemy_instance.connect("tree_exited", _on_enemy_killed)
		for node in nodes_connected:
			node.init_node(self)
	
	if music_to_play.stream != null:
		music_to_play.play()
		if Vars.main_scene.has_node("Music"):
			Vars.main_scene.get_node("Music").stop()
		if Vars.player != null:
			var stop_music = func():
				music_to_play.stop()
			Vars.player.die.connect(stop_music)

var enemies_killed : int = 0
var emitted := false
func _on_enemy_killed() -> void:
	enemies_killed += 1
	if enemies_killed < enemies_to_spawn.size() or emitted: return
	emitted = true
	
	for node in nodes_connected:
		node.emitter_node.emit_signal(node.signal_name)
	
	if Vars.main_scene.has_node("Music"):
		Vars.main_scene.get_node("Music").play()
	queue_free()
