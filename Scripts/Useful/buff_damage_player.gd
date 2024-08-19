extends Node

# Los dos valores siguientes, si no se los toca, no modifican el daño
## Añade (o saca) una cantidad de daño por porcentaje
@export var weight_to_modify := 1.0
## Añade (O saca) una cantidad en específico de daño, no por porcentaje
@export var amount_to_modify := 0.0

## Si el buff dura 0 o menos, es infinito
@export var duration := 0.0
## El color al que se modifica el jugador cuando tiene el buff. Si es black no modifica nada
@export var player_color : Color = Color.BLACK

# Se usa get_parent() y no Vars.player por si en algun momento se me canta añadir multijugador
# Este buff siempre debe ser hijo del jugador por ese motivo 
@onready var player := get_parent()

signal buff_removed
