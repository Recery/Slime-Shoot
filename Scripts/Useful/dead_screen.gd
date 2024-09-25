extends Control

func _ready():
	get_node("Score/Score/Total_Score").text = str(Vars.current_score)
	SaveSystem.get_curr_file().points += Vars.current_score
	SaveSystem.save_file()

func _on_menu_button_pressed():
	Events.change_scene.emit("res://Scenes/Menu/main_menu.tscn")
