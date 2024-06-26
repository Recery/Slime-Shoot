extends Node2D

# Los 4 parámetros de abajo son indispensables para cualquier habilidad
const cooldown = 35
const starter_cooldown = 15

var player
var can_use

# La habilidad debe contener un nodo "Ability_Frame" de sprite2D que muestra 
# el ícono de la habilidad
# También debe contener una label "Cooldown_Left" y un sprite2D "Energy_Use"
# El timer "Duration_Timer" es opcional, depende de la lógica de la habilidad si se usa o no
# Ese timer hace que la habilidad este activa hasta que se envíe la señal timeout

func _ready():
	player = Vars.player
	can_use = false

func can_be_activated():
	# Este método devuelve true si el jugador tiene suficiente energía para
	# usar la habilidad, de lo contrario devuelve false y no se usa la habilidad
	return player.reduce_energy(50, 2)

func activate():
	# Iniciar timer de duración de habilidad
	# La habilidad reproduce un sonido cuando se usa (Opcional)
	get_node("Duration_Timer").start()
	get_node("Use_Sound").play()
	# Añadir lógica cuando se activa la habilidad

func _on_duration_timer_timeout():
	# Lógica al terminar la habilidad
	# El timer se detiene para evitar que se vuelva a usar hasta que se
	# active de nuevo la habilidad
	get_node("Duration_Timer").stop()
