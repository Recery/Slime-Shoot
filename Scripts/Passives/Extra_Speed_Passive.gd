extends Node2D

func _ready():
	if Vars.player == null: return
	if not Vars.player.is_node_ready():
		await Vars.player.ready
	Vars.player.add_child(get_speed_buff())

func get_speed_buff() -> Buff_Player:
	var buff := Buff_Player.new()
	buff.speed_weight_to_modify = 1.10
	return buff
