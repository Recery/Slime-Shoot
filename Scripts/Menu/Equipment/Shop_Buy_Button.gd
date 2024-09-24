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

@export_group("Texture info")
@export var texture : Texture2D

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

func set_button_states() -> void:
	# Busca si el objeto que desbloquea este boton ya esta desbloqueado
	# De ya estar desbloqueado, el boton se deshabilita
	if get_unlocked_array().has(object_to_buy):
		disabled = true
		price_label.hide()
	else:
		disabled = false
		price_label.show()
	
	# Si el objeto es un slime, verifica si el slime se obtiene en la aventura o no
	# De obtenerse en la aventura, bloquea el boton
	if unlocked_in_adventure:
		if object_type == 0:
			disabled = true
			price_label.hide()
			get_node("Adventure_Advice").show()
			return
		elif not SaveSystem.get_curr_file().save_equipment.unlocked_slimes.has(unlocked_by_slime):
			disabled = true
			price_label.hide()
			get_node("Adventure_Advice").show()

func _pressed() -> void:
	if SaveSystem.get_curr_file().points < needed_points: return 
	
	disabled = true
	price_label.hide()
	
	get_unlocked_array().append(object_to_buy)
	SaveSystem.get_curr_file().points -= needed_points
	SaveSystem.save_file()
