extends Control

func _ready():
	get_node("Score/Score/Total_Score").text = str(Vars.current_score)
	Vars.total_points += Vars.current_score
	Save_System.save_total_points()

func _on_menu_button_pressed():
	Events.change_scene.emit("res://Scenes/Menu/main_menu.tscn")
