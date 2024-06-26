extends Node2D

var player

func _ready():
	player = Vars.player

func _on_regen_timer_timeout():
	if player.life <= 0: return
	
	if player.life + 3 <= player.max_life: player.life += 3
	else: player.life = player.max_life
