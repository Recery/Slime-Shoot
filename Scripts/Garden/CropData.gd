extends Resource
class_name CropData

## Las texturas de los distintos niveles de crecimiento, la primera es el primer nivel y la ultima el ultimo
@export var stages_textures : Array[Texture2D]

## El tiempo en segundos que tarda en crecer
@export var grow_time : int = 60
