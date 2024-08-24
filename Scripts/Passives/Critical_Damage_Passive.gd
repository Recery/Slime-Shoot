extends Node2D

func _ready():
	get_tree().node_added.connect(critical_damage)

func critical_damage(proj) -> void:
	if not Funcs.is_safe_damage(proj): return
	
	if not Funcs.probability(10): return
