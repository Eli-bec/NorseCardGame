class_name SlotsContainer
extends Node2D

func get_empty_slot() -> Slot:
	for slot in get_children():
		if slot.cards.size() < slot.capacity:
			return slot
	return null
