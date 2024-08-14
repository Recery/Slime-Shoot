extends Node

func _init():
	AudioServer.set_bus_volume_db(1, -60)
	AudioServer.set_bus_volume_db(2, -60)

func _ready():
	Events.change_scene.connect(_change_scene)
	Events.change_scene_packed.connect(_change_scene_packed)
	Events.change_scene_instance.connect(_change_scene_instance)

var loading_screen := preload("res://Scenes/Useful/loading_screen.tscn")
var has_loading_screen := false

func _change_scene(path_to_scene, show_loading_screen := true):
	for child in get_children():
		if child != null: child.queue_free()
	 
	if show_loading_screen:
		add_child(loading_screen.instantiate())
		has_loading_screen = true
		await get_tree().create_timer(0.5).timeout
	
	var new_scene : Node = load(path_to_scene).instantiate()
	call_deferred("add_child", new_scene)
	
	Vars.change_main_scene.emit(new_scene)
	
	if not new_scene.is_node_ready():
		await new_scene.ready
	has_loading_screen = false

func _change_scene_packed(scene : PackedScene, show_loading_screen := true):
	for child in get_children():
		if child != null: child.queue_free()
	
	if show_loading_screen:
		add_child(loading_screen.instantiate())
		has_loading_screen = true
		await get_tree().create_timer(0.5).timeout
	
	var new_scene := scene.instantiate()
	call_deferred("add_child", new_scene)
	
	Vars.change_main_scene.emit(new_scene)
	
	if not new_scene.is_node_ready():
		await new_scene.ready
	has_loading_screen = false

func _change_scene_instance(scene : Node, show_loading_screen := true):
	for child in get_children():
		if child != null: child.queue_free()
	
	if show_loading_screen:
		add_child(loading_screen.instantiate())
		has_loading_screen = true
		await get_tree().create_timer(0.5).timeout
	
	call_deferred("add_child", scene)
	
	Vars.change_main_scene.emit(scene)
	
	if not scene.is_node_ready():
		await scene.ready
	has_loading_screen = false
