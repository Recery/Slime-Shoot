extends Node2D

func _ready():
	get_tree().node_added.connect(critical_damage)

func get_damage_buff() -> Buff_Damage_Player:
	var buff := Buff_Damage_Player.new()
	buff.weight_to_add = 2
	buff.duration = 0
	buff.charges = 1
	buff.name = "Critical_Damage_Buff"
	return buff

func critical_damage(proj) -> void:
	if not proj.is_in_group("Friendly_Damage"): return
	if not Funcs.probability(10): return
	
	Vars.player.add_child(get_damage_buff())
