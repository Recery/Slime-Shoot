extends Node

func _ready():
	var despawn_timer := Timer.new()
	add_child(despawn_timer)
	despawn_timer.connect("timeout", _on_despawn)
	despawn_timer.start(30)

func _on_despawn():
	get_parent().queue_free()
