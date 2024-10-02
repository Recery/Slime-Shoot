extends Activable

var shop := preload("res://Scenes/Garden/GUI/seeds_shop.tscn")
var current_shop : Control
func _on_activated(_emitter):
	current_shop = shop.instantiate()
	Vars.main_scene.add_child(current_shop)
	current_shop.global_position = player.global_position
	get_tree().paused = true
	
	current_shop.get_node("BackButton").pressed.connect(delete_shop)

func delete_shop() -> void:
	get_tree().paused = false
	if current_shop != null:
		current_shop.queue_free()

func _input(event : InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if player_in_area: activated.emit(self)
