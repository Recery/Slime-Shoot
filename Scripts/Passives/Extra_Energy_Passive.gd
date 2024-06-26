extends Node2D

func _ready():
	await Vars.player.ready
	Vars.player.max_energy += 75
	Vars.player.energy = Vars.player.max_energy
