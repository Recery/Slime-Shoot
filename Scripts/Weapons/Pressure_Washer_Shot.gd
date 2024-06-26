extends Friendly_Projectile

var cannon : Node2D # Este nodo es el que va a usar como referencia para posicion
var pistol : Node2D # Para la rotacion

@onready var sprite = get_node("AnimatedSprite2D")

var enemies_inside := []

func _physics_process(_delta) -> void:
	# Este proyectil no se mueve por velocidad,
	# así que no importa reemplazar el physics_process original
	global_position = cannon.global_position
	rotation = pistol.rotation
	sprite.flip_v = pistol.flip_v

func _on_body_entered(body) -> void:
	if not body.is_in_group("Enemies"): return
	enemies_inside.append(body)

func _on_body_exited(body) -> void:
	if enemies_inside.has(body):
		enemies_inside.erase(body)

func _on_effects_timer_timeout() -> void:
	if not monitoring: return
	
	# Emitir esta señal para que otras habilidades
	# reinicien el proyectil cuando sea necesario
	reset_persistent.emit(self)
	
	# Este proyectil siempre es el mismo, se reutiliza
	# Por ese motivo es que se llama manualmente a la señal node_added
	get_tree().node_added.emit(self)
	
	# IMPORTANTE emitir primero reset_persistent y despues node_added
	# para que primero se reinicie y despues lo modifique ya reiniciado
	for enemy in enemies_inside:
		Funcs.deal_damage(enemy, damage)
		if not enemy.is_in_group("Big_Enemies") and not enemy.is_in_group("Boss"):
			enemy.add_child(Knockback.new(400))
