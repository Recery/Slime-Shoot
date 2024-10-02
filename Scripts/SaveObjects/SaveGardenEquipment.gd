extends Resource
class_name SaveGardenEquipment

@export var unlocked_seeds := [load("res://Scenes/Garden/Equipment/green_apple_seed_packet.tscn")]
@export var stored_seeds : Array[SeedPacketStored] = [get_seed_packet_stored(load("res://Scenes/Garden/Equipment/green_apple_seed_packet.tscn"), 1)]

func get_seed_packet_stored(packet : PackedScene, amount : int) -> SeedPacketStored:
	var seed_packet_stored := SeedPacketStored.new()
	seed_packet_stored.packet = packet
	seed_packet_stored.amount = amount
	return seed_packet_stored

func add_seed_packets(packet : PackedScene, amount_to_modify : int) -> void:
	for stored_seed in stored_seeds:
		if stored_seed.packet == packet:
			stored_seed.amount += amount_to_modify
			return
	
	var seed_packet_stored := SeedPacketStored.new()
	seed_packet_stored.packet = packet
	seed_packet_stored.amount = amount_to_modify
	stored_seeds.append(seed_packet_stored)
