extends Weapon
class_name SeedPacket

@export var crop_to_plant : PackedScene
@export var plant_projectile : Friendly_Projectile
@export var collision : CollisionShape2D

var effects_timer : Timer

func _ready() -> void:
	effects_timer = Timer.new()
	add_child(effects_timer)
	effects_timer.one_shot = true
	effects_timer.timeout.connect(_on_effects_timer_timeout)
	
	shoot.connect(_on_shoot)
	
	plant_projectile.add_to_group("Seed_Packet")

func get_crop() -> Crop:
	return crop_to_plant.instantiate()

var shooting := false
func _on_shoot() -> void:
	if not shooting: use_rotation()
	shooting = true
	collision.disabled = false
	plant_projectile.visible = true
	effects_timer.start(0.05)

func _on_effects_timer_timeout() -> void:
	collision.disabled = true
	plant_projectile.visible = false

func use_rotation():
	var original_rotation := rotation
	if flip_v: rotation_degrees = rad_to_deg(original_rotation) - 30
	else: rotation_degrees = rad_to_deg(original_rotation) + 30
	await get_tree().create_timer(0.2).timeout
	rotation = original_rotation
	shooting = false
