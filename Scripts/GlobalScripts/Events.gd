extends Node

signal change_scene(path_to_scene, show_loading_screen)
signal change_scene_packed(scene, show_loading_screen)
signal change_scene_instance(scene, show_loading_screen)

signal draw_equipped_slime()

func _init():
	## Siempre procesar, no tiene que estar pausado
	process_mode = Node.PROCESS_MODE_ALWAYS
	Input.joy_connection_changed.connect(joystick_connected)


func _physics_process(_delta : float) -> void:
	move_joystick_pos()

## Todo lo de joystick
var joystick_mode := false
func joystick_connected(_id : int, connected : bool) -> void:
	joystick_mode = connected
	
	if joystick_mode:
		Input.set_custom_mouse_cursor(load("res://Sprites/Useful/JoystickPosition.png"))
	else:
		Input.set_custom_mouse_cursor(load("res://Sprites/Useful/Cursor.png"))

func move_joystick_pos() -> void:
	if not joystick_mode: return
	
	var sum_pos := Vector2.ZERO
	const joystick_speed := 20
	
	if Input.is_action_pressed("controller_position_up"): sum_pos.y -= 1
	if Input.is_action_pressed("controller_position_down"): sum_pos.y += 1
	if Input.is_action_pressed("controller_position_left"): sum_pos.x -= 1
	if Input.is_action_pressed("controller_position_right"): sum_pos.x += 1
	
	var new_mouse_pos := get_viewport().get_mouse_position() + (sum_pos.normalized() * joystick_speed)
	if sum_pos != Vector2.ZERO: get_viewport().warp_mouse(new_mouse_pos)

func _input(event: InputEvent) -> void:
	if not joystick_mode: return
	
	if event is InputEventMouseButton: print(event.position)
	
	# Para emitir clicks del mouse con el joystick
	if event.is_action_pressed("perk"):
		var joy_click := InputEventMouseButton.new()
		joy_click.button_index = MOUSE_BUTTON_LEFT
		
		var viewport := get_viewport()
		var viewport_size := viewport.get_visible_rect().size
		var mouse_pos := viewport.get_mouse_position()
		var window_size := viewport.get_window().size
		var scale_x := window_size.x / viewport_size.x
		var scale_y := window_size.y / viewport_size.y
		joy_click.position = Vector2(mouse_pos.x * scale_x, mouse_pos.y * scale_y)
		
		joy_click.pressed = true
		Input.parse_input_event(joy_click)
	if event.is_action_released("perk"):
		var joy_click := InputEventMouseButton.new()
		joy_click.button_index = MOUSE_BUTTON_LEFT
		
		var viewport := get_viewport()
		var viewport_size := viewport.get_visible_rect().size
		var mouse_pos := viewport.get_mouse_position()
		var window_size := viewport.get_window().size
		var scale_x := window_size.x / viewport_size.x
		var scale_y := window_size.y / viewport_size.y
		joy_click.position = Vector2(mouse_pos.x * scale_x, mouse_pos.y * scale_y)
		
		joy_click.pressed = false
		Input.parse_input_event(joy_click)
