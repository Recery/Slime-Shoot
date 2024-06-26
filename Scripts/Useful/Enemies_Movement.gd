extends CanvasGroup

# Maneja el move_and_slide() de todos los enemigos hijos.
# Deberia mejorar el rendimiento al no hacerse individualmente en cada hijo.

func _ready():
	# Para que se muestren los enemigos como la gente
	y_sort_enabled = true

func _physics_process(_delta):
	for child in get_children():
		if child is CharacterBody2D:
			child.move_and_slide()
