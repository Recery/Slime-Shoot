extends Check_Button

func _init():
	checked = SaveSystem.get_settings_data().show_FPS_counter

func _on_pressed():
	await check()
	SaveSystem.get_settings_data().show_FPS_counter = checked
	Funcs.sound_play("res://Sounds/uiclick.mp3", 15)
	SaveSystem.save_settings_data()
