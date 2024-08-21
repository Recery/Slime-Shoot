extends Node2D

var player

# Esta pasiva hace que el jugador gane energia cada vez que mate un enemigo

func _ready():
	player = Vars.player
	player.add_score.connect(add_energy)

# Cada vez que se emite la señal de add_score del jugador, se llama a add_energy
# Se usa el puntaje que ganó el jugador para calcular la energía añadida
func add_energy(score_received, _enemy):
	var energy_to_add = score_received * 10
	if player.energy + energy_to_add < player.max_energy:
		player.energy += energy_to_add
	else: player.energy = player.max_energy
