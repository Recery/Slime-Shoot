extends Control

func resume():
	get_tree().paused = not get_tree().paused
	
	if get_tree().paused: show()
	else: hide()

func _input(_event):
	if Input.is_action_just_pressed("pause") && get_parent().life > 0: resume()

func _on_resume_pressed():
	resume()

func _on_menu_pressed():
	resume()
	Events.change_scene.emit("res://Scenes/Menu/main_menu.tscn")
