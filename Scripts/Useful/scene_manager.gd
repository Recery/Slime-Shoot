extends Node

func _init():
	AudioServer.set_bus_volume_db(1, -60)
	AudioServer.set_bus_volume_db(2, -60)

func _ready():
	Events.change_scene.connect(_change_scene)
	Events.change_scene_packed.connect(_change_scene_packed)
	Events.change_scene_instance.connect(_change_scene_instance)

func _change_scene(path_to_scene):
	for child in get_children():
		if child != null: child.queue_free()
	
	var new_scene : Node = load(path_to_scene).instantiate()
	call_deferred("add_child", new_scene)
	
	Vars.change_main_scene.emit(new_scene)

func _change_scene_packed(scene : PackedScene):
	for child in get_children():
		if child != null: child.queue_free()
	
	var new_scene := scene.instantiate()
	call_deferred("add_child", new_scene)
	
	Vars.change_main_scene.emit(new_scene)

func _change_scene_instance(scene : Node):
	for child in get_children():
		if child != null: child.queue_free()
	
	call_deferred("add_child", scene)
	Vars.change_main_scene.emit(scene)
