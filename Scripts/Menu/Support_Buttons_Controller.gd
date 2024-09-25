extends HBoxContainer

func _ready() -> void:
	create_timer()

func create_timer() -> void:
	var swap_buttons_timer := Timer.new()
	add_child(swap_buttons_timer)
	swap_buttons_timer.start(8)
	swap_buttons_timer.timeout.connect(swap_buttons)

func swap_buttons() -> void:
	for child in get_children():
		if not child is TextureButton: continue
		child.visible = not child.visible
