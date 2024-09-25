extends Resource
class_name SaveEquipment

@export var equipped_slime := load("res://Scenes/Player/Green_Slime/green_slime.tscn")
@export var unlocked_slimes := [load("res://Scenes/Player/Green_Slime/green_slime.tscn"), load("res://Scenes/Player/White_Slime/white_slime.tscn")]

@export var equipped_weapons := [load("res://Scenes/Weapons/weedtite_microgun.tscn"), null, null]
@export var unlocked_weapons := [load("res://Scenes/Weapons/weedtite_microgun.tscn")]

@export var equipped_abilities : Array[PackedScene] = [null, null, null]
@export var unlocked_abilities : Array[PackedScene] = []

@export var equipped_passives : Array[PackedScene] = [null, null, null]
@export var unlocked_passives : Array[PackedScene] = []

@export var equipped_hat : PackedScene = null
@export var unlocked_hats : Array[PackedScene] = []

@export var equipped_pet : PackedScene = null
@export var unlocked_pets : Array[PackedScene] = []
