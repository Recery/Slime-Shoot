extends TextureButton

## La cantidad de puntos necesarios para comprar este objeto
@export_group("Item info")
@export var needed_points = 100
## Que tipo de objeto compra el jugador con este boton
@export_enum("Slime", "Weapon", "Ability", "Passive", "Hat", "Pet") var type_of_object = 1
@export var object_to_buy : PackedScene

@export_group("Unlock info")
## Si se desbloquea con eventos en la aventura.
@export var unlocked_in_adventure = false
## Si no es un slime y el objeto se desbloquea en aventura,
## determina que slime lo desbloquea.
@export var unlocked_by_slime : PackedScene = load("res://Scenes/Player/Green_Slime/green_slime.tscn")

@export_group("Sprite info")
@export var sprite_to_display : Texture2D
@export var frames_display := 1

var unlocked_array

func _ready():
	connect("pressed", _on_pressed)
	get_node("Price").text = str(needed_points)
	get_node("Item").texture = sprite_to_display
	get_node("Item").hframes = frames_display
	
	# Dependiendo del tipo de objeto se elige el 
	# array correspondiente para guardar el objeto
	match type_of_object:
		0: unlocked_array = Vars.slimes_unlocked
		1: unlocked_array = Vars.weapons_unlocked
		2: unlocked_array = Vars.abilities_unlocked
		3: unlocked_array = Vars.passives_unlocked
		4: unlocked_array = Vars.hats_unlocked
		5: unlocked_array = Vars.pets_unlocked
	
	# Busca si el objeto que desbloquea este boton ya esta desbloqueado
	# De ya estar desbloqueado, el boton de deshabilita
	for i in range(unlocked_array.size()):
		if object_to_buy == unlocked_array[i]:
			disabled = true
			get_node("Price").hide()
			return
	
	# Si el objeto es un slime, verifica si el slime se obtiene en la aventura o no
	# De obtenerse en la aventura, bloquea el boton
	if unlocked_in_adventure:
		if type_of_object == 0:
			disabled = true
			get_node("Price").hide()
			get_node("Adventure_Advice").show()
			return
		elif not Vars.slimes_unlocked.has(unlocked_by_slime):
			disabled = true
			get_node("Price").hide()
			get_node("Adventure_Advice").show()

func _on_pressed():
	if Vars.total_points >= needed_points:
		
		Vars.total_points -= needed_points
		Save_System.save_total_points()
		disabled = true
		get_node("Price").hide()
		
		unlocked_array.append(object_to_buy)
		
		# Se llama al metodo para guardar lo desbloqueado
		# dependiendo del tipo de objeto comprado
		match type_of_object:
			0: Save_System.save_unlocked_slimes()
			1: Save_System.save_unlocked_weapons()
			2: Save_System.save_unlocked_abilities()
			3: Save_System.save_unlocked_passives()
			4: Save_System.save_unlocked_hats()
			5: Save_System.save_unlocked_pets()
