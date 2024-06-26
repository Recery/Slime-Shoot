extends Control

func _ready():
	get_node("Score/Total_Score").text = str(Vars.last_score)

func _on_menu_button_pressed():
	Vars.total_points += Vars.last_score
	Save_System.save_total_points()
	Events.change_scene.emit("res://Scenes/Menu/main_menu.tscn")
