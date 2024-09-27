extends TextureButton

@onready var back_button = get_parent().get_parent().get_parent().get_node("Back_Button")
@onready var dark_bg_description = get_parent().get_parent().get_parent().get_node("Dark_Background_Description")

@export var enemy : PackedScene

func _ready() -> void:
	set_button_state()
	Events.save_file_changed.connect(set_button_state)
	
	back_button.pressed.connect(_on_back_button_pressed)

func set_button_state() -> void:
	var active := SaveSystem.get_curr_file().almanac_unlocked.has(enemy.get_path())
	
	disabled = not active
	if has_node("Enemy_Sprite"): get_node("Enemy_Sprite").visible = active

func _pressed():
	activated = true
	Funcs.sound_play("res://Sounds/uiclick.mp3", 20)
	Vars.main_scene.get_node("BackButton").visible = false
	
	get_node("Enemy_Description").visible = true
	back_button.visible = true
	dark_bg_description.visible = true

var activated := false
func _on_back_button_pressed():
	if not activated: return
	activated = false
	Funcs.sound_play("res://Sounds/uiclick.mp3", 20)
	Vars.main_scene.get_node("BackButton").visible = true
	
	get_node("Enemy_Description").visible = false
	back_button.visible = false
	dark_bg_description.visible = false
