extends Node2D

@onready var stored_advice = get_node("Stored_Advice")

var player

# energy_stored se refiere a la energia guardada en este disco,
# no a la energia que usa el jugador
var energy_stored := 0
const max_energy := 400

func _ready():
	player = Vars.player
	player.add_score.connect(store_energy)
	stored_advice.visible = true

func store_energy(score_received):
	# La energia del disco no debe superar la energia maxima
	if energy_stored + score_received > max_energy: return
	energy_stored += score_received
	stored_advice.text = str(energy_stored)

func _on_restore_life_cooldown_timeout():
	# Si no hay energia guardada en el disco, no importa seguir
	# Si el jugador tiene 0 o menos vida, no tiene que regenerar vida
	if energy_stored <= 0 or player.life <= 0: return
	
	# Solo sumar 1 de vida si no excede la vida maxima
	# Restar la energia usada del disco ya que se uso para recuperar vida
	if player.life + 1 <= player.max_life:
		player.life += 1
		energy_stored -= 1
		stored_advice.text = str(energy_stored)
