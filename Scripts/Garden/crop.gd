extends Sprite2D
class_name Crop

@export var crop_data : CropData

var grow_timer : Timer

signal growed

func _ready() -> void:
	set_grow_timer()

func set_grow_timer() -> void:
	var timer := Timer.new()
	# "Divide" el timer en distintas secciones de tiempo, cada una representa una etapa de crecimiento
	timer.wait_time = float(crop_data.grow_time) / float(hframes)
	timer.timeout.connect(grow)
	add_child(timer)
	grow_timer = timer
	timer.start()

func get_grow_timer() -> Timer: return grow_timer

func grow() -> void:
	if frame + 1 >= hframes: return
	frame += 1
	growed.emit()

func is_full_grown() -> bool:
	return frame >= hframes - 1

func harvest() -> void:
	if not is_full_grown(): return
	
	SaveSystem.get_curr_file().points += 150
	SaveSystem.save_file()
	
	queue_free()
