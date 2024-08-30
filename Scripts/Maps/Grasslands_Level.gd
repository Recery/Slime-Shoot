extends Map

var dungeon_progress_bar : Node

var has_progress_bar := true

func _ready() -> void:
	player.add_score.connect(_on_add_score)
	
	Save_System.load_map_state(self)
	
	if not has_progress_bar: return
	dungeon_progress_bar = load("res://Scenes/Useful/progress_bar.tscn").instantiate()
	player.add_child(dungeon_progress_bar)
	await dungeon_progress_bar.ready
	dungeon_progress_bar.position = Vector2(-48.5, -53)
	dungeon_progress_bar.max_value = 300
	dungeon_progress_bar.min_value = 0
	dungeon_progress_bar.set_current_value(0)
	
	Vars.menu_map_photo = Vars.menu_maps.GRASSLANDS

func _on_add_score(score_added, _enemy) -> void:
	if not has_progress_bar:
		player.add_score.disconnect(_on_add_score)
	
	if Vars.current_score + score_added < 300 and dungeon_progress_bar != null: 
		dungeon_progress_bar.update_value.emit(score_added)
		return
	
	if dungeon_progress_bar != null:
		has_progress_bar = false
		spawn_ladder("res://Scenes/Maps/clown_dungeon.tscn")
		dungeon_progress_bar.queue_free()
