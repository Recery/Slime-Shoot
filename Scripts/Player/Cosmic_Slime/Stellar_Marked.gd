extends Node2D

var enemy : Node

func _ready():
	enemy = get_parent()
	position.y -= 10
	
	if enemy.has_signal("die"):
		enemy.connect("die", recover_energy)
	
	check_if_dying()

func recover_energy():
	if not enemy.is_queued_for_deletion():
		await enemy.tree_exiting
	Vars.player.energy += Vars.player.max_energy / 2.0

func check_if_dying():
	if "already_emitted" in enemy:
		if enemy.already_emitted: recover_energy()
