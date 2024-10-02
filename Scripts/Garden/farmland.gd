extends Area2D

enum farmland_state {DRY,WET}
@onready var sprite := get_node("Sprite2D") as Sprite2D
@onready var moisture_progress_bar := get_node("Moisture_Progress") as Node2D

var current_crop : Crop

const max_moisture_level := 10000
var moisture_level := 0

signal watered
signal drying

func _ready():
	set_moisture_progress_bar()

func set_moisture_progress_bar() -> void:
	moisture_progress_bar.set_color(Color.DEEP_SKY_BLUE)
	moisture_progress_bar.max_value = max_moisture_level
	moisture_progress_bar.min_value = 0
	moisture_progress_bar.current_value = moisture_level

func _on_area_entered(area: Area2D) -> void:
	# Detectar siembras y cosechas
	if area.is_in_group("Harvester") and current_crop != null: current_crop.harvest()
	elif area.is_in_group("Seed_Packet") and current_crop == null: add_crop(area.get_parent().get_crop())

func add_crop(new_crop : Crop) -> void:
	if current_crop != null: return
	
	Funcs.sound_play("res://Sounds/SeedPlant.mp3", 6, 1)
	current_crop = new_crop
	add_child(current_crop)
	move_child(moisture_progress_bar, current_crop.get_index())

func _physics_process(_delta: float) -> void:
	set_moisture_sprite()
	
	for area in get_overlapping_areas():
		# Detectar riego
		if area.is_in_group("Water"): water()
	
	
	# Si no existe el cultivo, no hay que pausar timer ni consumir humedad ya que no hay timer el cual pausar
	if current_crop != null:
		# Si el cultivo ya crecio del todo, no consumir agua
		if not current_crop.is_full_grown():
			current_crop.get_grow_timer().paused = not consume_moisture()
	
	moisture_progress_bar.set_current_value(moisture_level)

func water() -> void:
	if moisture_level < max_moisture_level: moisture_level += 50
	else: moisture_level = max_moisture_level

func consume_moisture() -> bool:
	if moisture_level > 0:
		moisture_level -= 1
		return true
	
	return false

func set_moisture_sprite() -> void:
	# Si la humedad es mayor a 0, usar el sprite mojado
	if moisture_level > 0: sprite.frame = farmland_state.WET
	# Sino, usar el sprite seco
	else: sprite.frame = farmland_state.DRY
