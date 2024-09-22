extends TextureButton

@export_enum("Slime", "Weapon", "Ability", "Passive", "Hat", "Pet") var type_of_object := 1
@export var info : ItemInfo

var obj_string : String
var root : Node

func _ready():
	if type_of_object == 0:
		root = get_parent().get_parent()
	else:
		root = get_parent().get_parent().get_parent()
	
	pressed.connect(_on_pressed)
	
	match type_of_object:
		0: obj_string = "Slime_Description"
		1: obj_string = "Weapon_Description"
		2: obj_string = "Ability_Description"
		3: obj_string = "Passive_Description"
		4: obj_string = "Hat_Description"
		5: obj_string = "Pet_Description"

var description := preload("res://Scenes/Menu/Equipment/description.tscn")
var slime_description := preload("res://Scenes/Menu/Equipment/slime_description.tscn")
func _on_pressed():
	var desc_instance : Control
	if type_of_object == 0: desc_instance = slime_description.instantiate()
	else: desc_instance = description.instantiate()
	
	Vars.main_scene.add_child(desc_instance)
	desc_instance.set_info(info)
	desc_instance.global_position = Vector2(-116,-72)
	Funcs.sound_play("res://Sounds/uiclick.mp3", 20)

