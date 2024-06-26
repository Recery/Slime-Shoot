extends Check_Button

func _init():
	checked = Vars.settings_data.show_FPS_counter

func _on_pressed():
	await check()
	Vars.settings_data.show_FPS_counter = checked
	Funcs.sound_play("res://Sounds/uiclick.mp3", 15)
	Save_System.save_settings()
