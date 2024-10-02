extends Resource
class_name SaveFile

@export var points := 500

@export var save_equipment := SaveEquipment.new()

@export var save_garden_equipment := SaveGardenEquipment.new()

@export var cinematics_played : Array[int] = []

@export var almanac_unlocked : Array[String] = []
