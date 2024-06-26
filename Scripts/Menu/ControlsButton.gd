extends Control

func _ready():
	global_position = Vector2(0,0)

func _on_next_button_pressed():
	Funcs.sound_play("res://Sounds/uiclick.mp3", 20)
	get_node("ControlsCont").hide()
	get_node("ControlsCont2").show()
	get_node("Next_Button").hide()
	get_node("Back_Button").show()

func _on_back_button_pressed():
	Funcs.sound_play("res://Sounds/uiclick.mp3", 20)
	get_node("ControlsCont").show()
	get_node("ControlsCont2").hide()
	get_node("Next_Button").show()
	get_node("Back_Button").hide()
