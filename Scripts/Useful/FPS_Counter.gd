extends Label

func _ready():
	var update_cooldown := Timer.new()
	add_child(update_cooldown)
	update_cooldown.connect("timeout", _update_timeout)
	update_cooldown.start(1)

func _update_timeout():
	text = str(Engine.get_frames_per_second())
