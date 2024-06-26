extends Node2D

var player

func _ready():
	player = Vars.player
	await player.ready
	add_resistance()

func add_resistance():
	player.resistance += 2
