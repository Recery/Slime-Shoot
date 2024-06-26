extends Node2D

var player
var mini_bots = [null, null]

func _ready():
	player = Vars.player
	
	for i in range(mini_bots.size()):
		mini_bots[i] = load("res://Scenes/Passives/mini_bot.tscn").instantiate()
		if i == 0: 
			mini_bots[i].idle_pos = Vector2(player.global_position.x - 10, player.global_position.y)
		else:
			mini_bots[i].idle_pos = Vector2(player.global_position.x + 10, player.global_position.y)
		mini_bots[i].global_position = player.global_position
		Vars.main_scene.get_node("Summons").add_child(mini_bots[i])

func _physics_process(_delta):
	for i in range(mini_bots.size()):
		if i == 0: 
			mini_bots[i].idle_pos = Vector2(player.global_position.x - 10, player.global_position.y)
		else:
			mini_bots[i].idle_pos = Vector2(player.global_position.x + 10, player.global_position.y)
