extends Node2D

var player : Player
var mini_bots : Array[Node2D] = [null, null]

func _ready():
	player = Vars.player
	
	for i in range(mini_bots.size()):
		mini_bots[i] = load("res://Scenes/Passives/mini_bot.tscn").instantiate()
		if Funcs.add_to_summons(mini_bots[i]):
			mini_bots[i].global_position = player.global_position
			player.summons_module.add_minion(mini_bots[i])
		else: mini_bots[i].queue_free()
