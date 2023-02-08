class_name SlotsContainer
extends Node2D

func get_empty_slot() -> Slot:
	for slot in get_children():
		if slot.is_empty():
			return slot
	return null
