extends TextureButton

var back_button

var activated

@export_enum("Slime", "Weapon", "Ability", "Passive", "Hat") var type_of_object := 1

var obj_string : String
var root : Node

func _ready():
	if type_of_object == 0:
		root = get_parent().get_parent()
	else:
		root = get_parent().get_parent().get_parent()
	
	back_button = root.get_node("Back_Button")
	activated = false
	connect("pressed", _on_pressed)
	back_button.connect("pressed", _on_back_button_pressed)
	
	match type_of_object:
		0: obj_string = "Slime_Description"
		1: obj_string = "Weapon_Description"
		2: obj_string = "Ability_Description"
		3: obj_string = "Passive_Description"
		4: obj_string = "Hat_Description"

func _on_pressed():
	activated = true
	get_node(obj_string).show()
	Funcs.sound_play("res://Sounds/uiclick.mp3", 20)
	root.get_node("Dark_Background_Description").show()
	Vars.main_scene.get_node("BackButton").hide()
	back_button.show()

func _on_back_button_pressed():
	if activated:
		activated = false
		get_node(obj_string).hide()
		root.get_node("Dark_Background_Description").hide()
		Funcs.sound_play("res://Sounds/uiclick.mp3", 20)
		Vars.main_scene.get_node("BackButton").show()
		back_button.hide()
