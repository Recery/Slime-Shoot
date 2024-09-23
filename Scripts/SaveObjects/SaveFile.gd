extends Resource
class_name SaveFile

@export var slot : int

@export var points := 500

@export var save_equipment := SaveEquipment.new()

@export var cinamatics_played : Array[int] = []

@export var save_settings := SettingsData.new()

@export var almanac_unlocked : Array[String] = []

func save() -> void:
	ResourceSaver.save(self, "user://save_data/save_" + str(slot) + ".res")
