extends TextureButton

## El nodo principal de la pagina que muestra este botón
@export var page_to_enter : Node

@onready var parent_container := get_parent()

func _ready():
	pressed.connect(_on_pressed)
	
	add_to_group("Page_Button")

func _on_pressed():
	for child in parent_container.get_children():
		if child.is_in_group("Page_Button") and child is TextureButton:
			child.page_to_enter.visible = false
			child.disabled = false
	
	page_to_enter.visible = true
	disabled = true
