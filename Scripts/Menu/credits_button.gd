extends Control

@onready var box_1 := get_node("Credits_Box")
@onready var box_2 := get_node("Credits_Box2")

@onready var next_button := get_node("Next_Button")
@onready var back_button := get_node("Back_Button")

func _on_next_button_pressed():
	box_1.hide()
	next_button.hide()
	box_2.show()
	back_button.show()
	Funcs.sound_play("res://Sounds/uiclick.mp3", 20)

func _on_back_button_pressed():
	box_1.show()
	next_button.show()
	box_2.hide()
	back_button.hide()
	Funcs.sound_play("res://Sounds/uiclick.mp3", 20)
