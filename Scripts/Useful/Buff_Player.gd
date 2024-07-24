extends Node
class_name Buff_Player

@export var speed_weight_to_modify := 1.0

## Si el buff dura 0 o menos, es infinito
@export var duration := 0.0
## El color al que se modifica el jugador cuando tiene el buff. Si es black no modifica nada
@export var player_color : Color = Color.BLACK

# Se usa get_parent() y no Vars.player por si en algun momento se me canta añadir multijugador
# Este buff siempre debe ser hijo del jugador por ese motivo 
@onready var player := get_parent()

signal buff_removed

func _init():
	connect("ready", _on_ready)

var duration_timer : Timer
func _on_ready():
	if player_color != Color.BLACK: add_to_group("Color_Debuff")
	
	player.child_exiting_tree.connect(apply_buff)
	
	apply_buff(null)
	
	if duration > 0:
		duration_timer = Timer.new()
		add_child(duration_timer)
		duration_timer.wait_time = duration
		duration_timer.start()
		duration_timer.connect("timeout", remove_buff)

func apply_buff(applied_buff : Node):
	if applied_buff != null and applied_buff != self and player_color != Color.BLACK:
		if applied_buff.is_in_group("Color_Debuff"): player.modulate = player_color
	
	if applied_buff == self: return
	if not applied_buff is Buff_Player and applied_buff != null: return
	
	player.speed *= speed_weight_to_modify
	
	if player_color != Color.BLACK:
		if player.has_node("Slime"):
			player.get_node("Slime").self_modulate = player_color
		if player.has_node("Hat"):
			player.get_node("Hat").self_modulate = player_color
	
	print("Velocidad: ", player.speed)

func remove_buff():
	player.speed = player.original_speed
	
	if player.has_node("Slime"):
		player.get_node("Slime").self_modulate = Color(1,1,1)
	if player.has_node("Hat"):
		player.get_node("Hat").self_modulate = Color(1,1,1)
	
	emit_signal("buff_removed")
	queue_free()
