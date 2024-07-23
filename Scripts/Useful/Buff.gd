extends Node
class_name Buff

## Que estadística se modifica
@export_enum("Speed", "Damage") var stat_to_modify : String
## Si es un buff (mejora) o debuff (empeora)
@export_enum("Buff", "Debuff") var type : String
## Cuanto se modífica la estadística deseada
@export var weight_to_modify := 2.0
## Cuánto dura el buff. Si es 0, dura para siempre.
@export var duration := 5.00
## Un color para modificar el del enemigo cuando tiene el buff
@export var enemy_color : Color = Color.BLACK

@onready var enemy := get_parent()

## La señal que se emite cuando el buff se elimina
signal buff_removed

func _init():
	connect("ready", _on_ready)

var duration_timer : Timer
func _on_ready():
	if enemy_color != Color.BLACK: add_to_group("Color_Debuff")
	
	enemy.child_exiting_tree.connect(apply_debuff)
	
	apply_debuff(null)
	
	if duration > 0:
		duration_timer = Timer.new()
		add_child(duration_timer)
		duration_timer.wait_time = duration
		duration_timer.start()
		duration_timer.connect("timeout", remove_debuff)

func reset_duration() -> void:
	if duration_timer == null: return
	duration_timer.start()

func apply_debuff(node) -> void:
	if node != null and node != self and enemy_color != Color.BLACK:
		if node.is_in_group("Color_Debuff"): enemy.modulate = enemy_color
	
	if node is Buff:
		if not node.stat_to_modify == stat_to_modify or node == self:
			return
	elif not node is Knockback and node != null:
		return
	
	# Si es knockback u otro buff que modifique una estadística,
	# hay que reiniciar las estadísticas de este enemigo de acuerdo
	# a lo que dice este buff
	
	match stat_to_modify:
		"Speed": 
			if type == "Buff":
				enemy.speed *= weight_to_modify
			else: # Es debuff
				enemy.speed /= weight_to_modify
		"Damage": 
			if type == "Buff":
				enemy.damage *= weight_to_modify
			else: # Es debuff
				enemy.damage /= weight_to_modify
	
	if enemy_color != Color.BLACK and not node is Knockback:
		# El knockback no modifica el color, no hay que renovar el color en ese caso
		enemy.modulate = enemy_color
	
	enemy.apply_new_speed()

func remove_debuff():
	match stat_to_modify:
		"Speed":
			enemy.speed = enemy.base_speed
			enemy.apply_new_speed()
		"Damage":
			enemy.damage = enemy.base_damage
	
	enemy.modulate = Color(1, 1, 1)
	
	emit_signal("buff_removed")
	queue_free()
