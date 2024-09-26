extends Node

const dir_path : String = "user://save_data"

# El archivo de SettingsData es siempre el mismo, se comparte con todos los demas archivos de guardado
var settings_data : SettingsData
var save_files : Array[SaveFile] = [SaveFile.new(), SaveFile.new(), SaveFile.new(), SaveFile.new(), SaveFile.new(), SaveFile.new()]

func _init() -> void:
	if not DirAccess.dir_exists_absolute(dir_path):
		# No existe el directorio, lo creo
		DirAccess.make_dir_absolute(dir_path)
	
	load_settings_data()
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

func load_saves() -> void:
	for slot in range(save_files.size()):
		if not is_file_saved(slot): continue
		
		var file_res := ResourceLoader.load(get_save_file_path(slot))
		if file_res != null:
			if file_res is SaveFile:
				save_files[slot] = file_res
			else:
				# Archivo corrupto, borrarlo
				# No hace falta verificar por archivos corruptos mas adelante ya que solo los carga aca al iniciar el juego
				DirAccess.remove_absolute(get_save_file_path(slot))
	
	if not is_file_saved(settings_data.curr_save_slot):
		# Si por algun motivo el save del slot actual no esta guardado en disco, lo guarda en el disco 
		# (va a ser siempre un archivo nuevo ya que no estaba en el disco y por lo tanto no hay nada para cargar)
		save_file(settings_data.curr_save_slot)

func get_settings_data() -> SettingsData:
	if settings_data == null: settings_data = SettingsData.new()
	return settings_data

func save_settings_data() -> void:
	# Se obtiene settings data con el metodo y no usandolo directamente ya que el metodo nunca devuelve null
	ResourceSaver.save(get_settings_data(), dir_path + "/settings_data.res")

func save_file(slot : int = settings_data.curr_save_slot) -> bool:
	if save_files.size() <= slot or slot < 0: return false
	if save_files[slot] == null: return false
	
	return ResourceSaver.save(save_files[slot], get_save_file_path(slot))

func set_curr_file(new_slot : int) -> void:
	settings_data.curr_save_slot = new_slot
	save_settings_data()
	Events.save_file_changed.emit()
	Events.draw_equipped_slime.emit()

func get_curr_file() -> SaveFile:
	if save_files.size() <= settings_data.curr_save_slot or settings_data.curr_save_slot < 0:
		set_curr_file(0)
		return save_files[0]
	if save_files[settings_data.curr_save_slot] == null:
		set_curr_file(0)
		return save_files[0]
	
	return save_files[settings_data.curr_save_slot]

func get_save_file(slot : int) -> SaveFile:
	if save_files.size() <= slot or slot < 0: return SaveFile.new()
	if save_files[slot] == null: return SaveFile.new()
	
	return save_files[slot]

func delete_save_file(slot : int) -> void:
	if save_files.size() <= slot or slot < 0: return
	if save_files[slot] == null: return
	
	if FileAccess.file_exists(get_save_file_path(slot)):
		DirAccess.remove_absolute(get_save_file_path(slot))
	save_files[slot] = SaveFile.new()

func is_file_saved(slot : int) -> bool:
	return FileAccess.file_exists(get_save_file_path(slot))

func get_save_file_path(slot : int) -> String:
	return dir_path + "/save_" + str(slot+1) + ".res"
