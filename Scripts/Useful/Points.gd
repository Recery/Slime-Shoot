extends Label

func _process(_delta):
	text = str(SaveSystem.get_curr_file().points)
