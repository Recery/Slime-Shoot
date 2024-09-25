extends Resource
class_name SaveFile

@export var points := 500000

@export var save_equipment := SaveEquipment.new()

@export var cinematics_played : Array[int] = []

@export var save_settings := SettingsData.new()

@export var almanac_unlocked : Array[String] = []

# Si este archivo esta guardado
@export var saved := false
