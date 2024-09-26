extends Node

const dir_path : String = "user://save_data"

# El archivo de SettingsData es siempre el mismo, se comparte con todos los demas archivos de guardado
var settings_data : SettingsData
var save_files : Array[SaveFile] = [SaveFile.new(), SaveFile.new(), SaveFile.new(), SaveFile.new(), SaveFile.new(), SaveFile.new()]
var curr_slot := 0

func _init() -> void:
	load_settings_data()
	load_current_slot()
	load_saves()

func load_settings_data() -> void:
	var file := dir_path + "/settings_data.res"
	if FileAccess.file_exists(file):
		var loaded_settings_data := ResourceLoader.load(file)
		if loaded_settings_data is SettingsData:
			settings_data = loaded_settings_data
			# Archivo cargado, volver
			return
	
	# En este punto, por algun motivo el archivo no se cargo, asi que se crea uno nuevo
	settings_data = SettingsData.new()

func load_current_slot() -> void:
	const file_name := "res://current_slot.save"
	if FileAccess.file_exists(file_name):
		var file := FileAccess.open(file_name, FileAccess.READ)
		curr_slot = file.get_var()
		file.close()

func load_saves() -> void:
	var dir := get_safe_dir()
	
	for slot in range(save_files.size()):
		if dir.file_exists("save_" + str(slot+1) + ".res"):
			var file := ResourceLoader.load(dir_path + "/save_" + str(slot+1) + ".res")
			if file != null and file is SaveFile:
				save_files[slot] = file
				save_files[slot].saved = true

func get_settings_data() -> SettingsData:
	if settings_data == null: settings_data = SettingsData.new()
	return settings_data

func save_settings_data() -> void:
	# Se obtiene settings data con el metodo y no usandolo directamente ya que el metodo nunca devuelve null
	ResourceSaver.save(get_settings_data(), dir_path + "/settings_data.res")

func save_current_slot() -> void:
	const file_name := "res://current_slot.save"
	var file := FileAccess.open(file_name, FileAccess.WRITE)
	file.store_var(curr_slot)
	file.close()

func get_safe_dir() -> DirAccess:
	if not DirAccess.dir_exists_absolute(dir_path):
		# No existe el directorio, lo creo
		DirAccess.make_dir_absolute(dir_path)
	return DirAccess.open(dir_path)

func save_file(slot := curr_slot) -> bool:
	if save_files.size() < slot or slot < 0: return false
	if save_files[slot] == null: return false
	
	save_files[slot].saved = true
	return ResourceSaver.save(save_files[slot], dir_path + "/save_" + str(slot+1) + ".res")

func set_curr_file(new_slot : int) -> void:
	curr_slot = new_slot
	Events.save_file_changed.emit()
	save_current_slot()
	Events.draw_equipped_slime.emit()

func get_curr_file() -> SaveFile:
	if save_files.size() < curr_slot or curr_slot < 0: return SaveFile.new()
	if save_files[curr_slot] == null: return SaveFile.new()
	
	return save_files[curr_slot]

func get_save_file(slot : int) -> SaveFile:
	if save_files.size() <= slot or slot < 0: return SaveFile.new()
	if save_files[slot] == null: return SaveFile.new()
	
	return save_files[slot]

func delete_save_file(slot : int) -> void:
	if save_files.size() < slot or slot < 0: return
	if save_files[slot] == null: return
	
	var file := dir_path + "/save_" + str(slot+1) + ".res"
	if FileAccess.file_exists(file):
		DirAccess.remove_absolute(file)
	save_files[slot] = SaveFile.new()
