extends Node2D
class_name Ability

@export_group("Cooldown")
@export var cooldown := 55
@export var starter_cooldown := 25

@export_group("Energy")
@export var energy_use := 50
@export var energy_recover_time := 1.0

@onready var player := Vars.player
@onready var can_use := false

signal activate
signal modify_cooldown(emitter, amount)

func _init():
	ready.connect(_on_ready)

var energy_use_ui := preload("res://Scenes/Abilities/ability_energy_use.tscn")
var ability_cooldown_left := preload("res://Scenes/Abilities/ability_cooldown_left.tscn")
func _on_ready():
	var energy_use_ui_instance := energy_use_ui.instantiate()
	energy_use_ui_instance.get_node("Use").text = str(energy_use)
	add_child(energy_use_ui_instance)
	
	add_child(ability_cooldown_left.instantiate())

func can_be_activated() -> bool:
	return player.reduce_energy(energy_use, energy_recover_time)
