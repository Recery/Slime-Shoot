extends Node

signal change_scene(path_to_scene, show_loading_screen)
signal change_scene_packed(scene, show_loading_screen)
signal change_scene_instance(scene, show_loading_screen)

signal draw_equipped_slime()

func _init():
	## Siempre procesar, no tiene que estar pausado
	process_mode = Node.PROCESS_MODE_ALWAYS

## Mover posicion joystick
func _physics_process(_delta : float) -> void:
	move_joystick_pos()

func move_joystick_pos() -> void:
	var sum_pos := Vector2.ZERO
	const joystick_speed := 20
	
	if Input.is_action_pressed("controller_position_up"): sum_pos.y -= 1
	if Input.is_action_pressed("controller_position_down"): sum_pos.y += 1
	if Input.is_action_pressed("controller_position_left"): sum_pos.x -= 1
	if Input.is_action_pressed("controller_position_right"): sum_pos.x += 1
	
	var new_mouse_pos := get_viewport().get_window().get_mouse_position() + (sum_pos.normalized() * joystick_speed)
	if sum_pos != Vector2.ZERO: get_viewport().warp_mouse(new_mouse_pos)

func _input(event: InputEvent) -> void:
	# Para emitir clicks del mouse con el joystick
	if event.is_action_pressed("perk"):
		var joy_click := InputEventMouseButton.new()
		joy_click.button_index = MOUSE_BUTTON_LEFT
		joy_click.position = get_viewport().get_window().get_mouse_position()
		joy_click.pressed = true
		Input.parse_input_event(joy_click)
	elif event.is_action_released("perk"):
		var joy_click := InputEventMouseButton.new()
		joy_click.button_index = MOUSE_BUTTON_LEFT
		joy_click.position = get_viewport().get_window().get_mouse_position()
		joy_click.pressed = false
		Input.parse_input_event(joy_click)
