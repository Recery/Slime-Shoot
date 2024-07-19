extends Sprite2D

# Sirve para mover la sombra en base a un sprite

## El sprite en base al que se mueve la sombra. Puede ser AnimatedSprite o solo Sprite
@export var sprite : Node
@export var first_pos : Vector2
@export var second_pos : Vector2

func _physics_process(_delta):
	if sprite == null: return
	
	if sprite.flip_h:
		position = second_pos
	else:
		position = first_pos
