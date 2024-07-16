extends Control

@onready var next_button := get_node("Next_Button")
@onready var back_button := get_node("Back_Button")

var current_page := 1

func _on_next_button_pressed():
	current_page += 1
	
	if current_page > 3: current_page = 3
	
	buttons_visibility()
	
	for child in get_children():
		if not child.is_in_group("Credits_Box"): continue
		child.visible = child.name == "Credits_Box" + str(current_page)
	
	Funcs.sound_play("res://Sounds/uiclick.mp3", 20)

func _on_back_button_pressed():
	current_page -= 1
	
	if current_page < 1: current_page = 1
	
	buttons_visibility()
	
	for child in get_children():
		if not child.is_in_group("Credits_Box"): continue
		child.visible = child.name == "Credits_Box" + str(current_page)
	
	Funcs.sound_play("res://Sounds/uiclick.mp3", 20)

func buttons_visibility():
	if current_page != 1 and current_page != 3:
		next_button.visible  = true
		back_button.visible = true
	elif current_page == 3:
		next_button.visible  = false
		back_button.visible = true
	elif current_page == 1:
		next_button.visible  = true
		back_button.visible = false
