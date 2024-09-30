extends Resource
class_name SaveEquipment

@export var equipped_slime := load("res://Scenes/Player/Green_Slime/green_slime.tscn")
@export var unlocked_slimes := [load("res://Scenes/Player/Green_Slime/green_slime.tscn")]

@export var equipped_weapons := [load("res://Scenes/Garden/Equipment/green_apple_seed_packet.tscn"),
load("res://Scenes/Garden/Equipment/watering_can.tscn"),
load("res://Scenes/Garden/Equipment/scythe.tscn")]
@export var unlocked_weapons := [load("res://Scenes/Weapons/weedtite_microgun.tscn")]

@export var equipped_abilities : Array[PackedScene] = [null, null, null]
@export var unlocked_abilities : Array[PackedScene] = []

@export var equipped_passives : Array[PackedScene] = [null, null, null]
@export var unlocked_passives : Array[PackedScene] = []

@export var equipped_hat : PackedScene = null
@export var unlocked_hats : Array[PackedScene] = []

@export var equipped_pet : PackedScene = null
@export var unlocked_pets : Array[PackedScene] = []
