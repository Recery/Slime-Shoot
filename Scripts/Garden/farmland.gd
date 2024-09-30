extends Area2D

enum farmland_state {DRY,WET}
@onready var sprite := get_node("Sprite2D") as Sprite2D

var current_crop : Crop

signal watered
signal drying

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Water"): water()
	elif area.is_in_group("Harvester") and current_crop != null: current_crop.harvest()
	elif area.is_in_group("Seed_Packet") and current_crop == null: add_crop(area.get_parent().get_crop())

func add_crop(new_crop : Crop) -> void:
	if current_crop != null: return
	
	current_crop = new_crop
	add_child(current_crop)
	
	current_crop.growed.connect(dry)

func _physics_process(_delta: float) -> void:
	if current_crop == null: return
	
	current_crop.get_grow_timer().paused = not is_watered()

func water() -> void:
	sprite.frame = farmland_state.WET

func dry() -> void:
	sprite.frame = farmland_state.DRY

func is_watered() -> bool:
	return sprite.frame == farmland_state.WET
