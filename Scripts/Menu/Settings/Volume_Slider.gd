extends HSlider

@export var bus_index := 0

func _ready():
	var volume : int
	if bus_index == 1:
		volume = SaveSystem.get_settings_data().sound_volume
		if volume <= -30:
			AudioServer.set_bus_mute(bus_index, true)
		else:
			AudioServer.set_bus_volume_db(bus_index, volume)
	else:
		volume = SaveSystem.get_settings_data().music_volume
		if volume <= -30:
			AudioServer.set_bus_mute(bus_index, true)
		else:
			AudioServer.set_bus_volume_db(bus_index, volume)
	
	value = volume

func _on_value_changed(val):
	AudioServer.set_bus_volume_db(bus_index, val)
	if val <= -30:
		AudioServer.set_bus_mute(bus_index, true)
	else:
		AudioServer.set_bus_mute(bus_index, false)
	
	match bus_index:
		1: SaveSystem.get_settings_data().sound_volume = val
		2: SaveSystem.get_settings_data().music_volume = val
	SaveSystem.save_settings_data()
