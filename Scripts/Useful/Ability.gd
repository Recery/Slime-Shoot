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

func can_be_activated() -> bool:
	return player.reduce_energy(energy_use, energy_recover_time)
