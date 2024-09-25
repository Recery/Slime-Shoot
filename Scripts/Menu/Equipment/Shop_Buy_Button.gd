extends TextureButton

enum object_types {SLIME, WEAPON, ABILITY, PASSIVE, HAT, PET}

## La cantidad de puntos necesarios para comprar este objeto
@export_group("Item info")
@export var needed_points = 100
## Que tipo de objeto compra el jugador con este boton
@export var object_type := object_types.WEAPON
@export var object_to_buy : PackedScene

@export_group("Unlock info")
## Si se desbloquea con eventos en la aventura.
@export var unlocked_in_adventure = false
## Si no es un slime y el objeto se desbloquea en aventura,
## determina que slime lo desbloquea.
@export var unlocked_by_slime : PackedScene = load("res://Scenes/Player/Green_Slime/green_slime.tscn")

@export_group("Other info")
@export var texture : Texture2D
@export var description_info : ItemInfo

@onready var price_label := get_node("Price") as Label

var unlocked_array : Array

func _ready() -> void:
	price_label.text = str(needed_points)
	get_node("Item").texture = texture
	
	Events.save_file_changed.connect(set_button_states)
	set_button_states()

func get_unlocked_array() -> Array:
	match object_type:
		0: return SaveSystem.get_curr_file().save_equipment.unlocked_slimes
		1: return SaveSystem.get_curr_file().save_equipment.unlocked_weapons
		2: return SaveSystem.get_curr_file().save_equipment.unlocked_abilities
		3: return SaveSystem.get_curr_file().save_equipment.unlocked_passives
		4: return SaveSystem.get_curr_file().save_equipment.unlocked_hats
		5: return SaveSystem.get_curr_file().save_equipment.unlocked_pets
		_: return SaveSystem.get_curr_file().save_equipment.unlocked_weapons

@onready var adventure_advice := get_node("Adventure_Advice")
func set_button_states() -> void:
	# Lo esconde siempre para reiniciarlo correctamente cuando se llama de nuevo a este metodo
	adventure_advice.hide()
	
	# Busca si el objeto que desbloquea este boton ya esta desbloqueado
	# De ya estar desbloqueado, el boton se deshabilita
	if get_unlocked_array().has(object_to_buy):
		disabled = true
		price_label.hide()
		return
	else:
		disabled = false
		price_label.show()
	
	# Si el objeto se desbloquea en la aventura y no se tiene el slime correspondiente, bloquea el boton
	if unlocked_in_adventure:
		if not SaveSystem.get_curr_file().save_equipment.unlocked_slimes.has(unlocked_by_slime) or object_type == object_types.SLIME:
			disabled = true
			price_label.hide()
			adventure_advice.show()

var description := preload("res://Scenes/Menu/Equipment/description.tscn")
var slime_description := preload("res://Scenes/Menu/Equipment/slime_description.tscn")
var buy_button := preload("res://Scenes/Menu/Shop/buy_button.tscn")
var curr_description : Control
func _pressed() -> void:
	if object_type == object_types.SLIME: curr_description = slime_description.instantiate()
	else: curr_description = description.instantiate()
	
	Vars.main_scene.add_child(curr_description)
	curr_description.set_info(description_info)
	curr_description.global_position = Vector2(-116,-76)
	Funcs.sound_play("res://Sounds/uiclick.mp3", 20)
	
	var buy_button_instance := buy_button.instantiate()
	curr_description.add_child(buy_button_instance)
	buy_button_instance.position = Vector2(78, 132)
	buy_button_instance.get_node("Points/Points").text = str(needed_points)
	if not buy_button_instance.pressed.is_connected(buy):
		buy_button_instance.pressed.connect(buy)

func buy() -> void:
	if SaveSystem.get_curr_file().points < needed_points: return
	
	if curr_description != null: curr_description.queue_free()
	Funcs.sound_play("res://Sounds/BuySound.mp3", 12, 1.1)
	
	disabled = true
	price_label.hide()
	
	get_unlocked_array().append(object_to_buy)
	SaveSystem.get_curr_file().points -= needed_points
	SaveSystem.save_file()
