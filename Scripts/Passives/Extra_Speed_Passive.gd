extends Node2D

var player

func _ready():
	player = Vars.player
	await player.ready
	set_player_speed()

func set_player_speed():
	player.speed *= 1.16
