extends TextureButton
class_name  Check_Button

var checked := false

func _ready():
	get_node("Cross").visible = checked

func check():
	checked = not checked
	get_node("Cross").visible = checked
