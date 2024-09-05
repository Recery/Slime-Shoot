extends Node2D

func _ready():
	get_tree().node_added.connect(critical_damage)

func critical_damage(proj) -> void:
	if not Funcs.is_safe_damage(proj): return
	if has_buff: return
	if not Funcs.probability(5): return
	
	Vars.player.add_child(get_damage_buff())

var has_buff := false
func get_damage_buff() -> Buff_Damage_Player:
	var buff := Buff_Damage_Player.new()
	buff.weight_to_add = 2
	buff.duration = 1
	has_buff = true
	buff.tree_exited.connect(func(): has_buff = false)
	return buff
