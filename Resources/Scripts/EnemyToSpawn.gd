extends Resource
class_name EnemyToSpawn

## El enemigo a spawnear.
@export var enemy : PackedScene
## Una probabilidad base de que aparezca la cuál se va modificando dependiendo del nivel.
@export var probability : float
## El nivel de spawner en el que empieza a spawnear el enemigo.
@export var level_to_spawn : int
## El nivel máximo (inclusive) de spawner hasta el que aparece el enemigo.
## Si es 0, no hay nivel máximo.
@export var max_level_to_spawn := 0
