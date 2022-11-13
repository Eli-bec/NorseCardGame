extends Node

@export var HandSlotScene:PackedScene

var slotSize:Vector2

var slots:Array[Sprite2D] = []

func _ready():
	# instantiate hand slots
	print("Instantiating HandSlots (x{size})".format({'size': Config.hand_size}))
	for n in range(Config.hand_size):
		slots.append(HandSlotScene.instantiate())
		add_child(slots[-1])
	# calculate positions
	slotSize = slots[0].get_rect().size * slots[0].scale
	var y = get_viewport().size.y - slotSize.y / 2
	# derived from 'slotSize.x * (Config.hand_size - 1) + Constants.HAND_slots_GAP * (Config.hand_size - 1)'
	# as the positions of the slots are the center of the sprites
	var total_width = (slotSize.x + Constants.HAND_SLOTS_GAP) * (Config.hand_size - 1)
	var x = (get_viewport().size.x - total_width) / 2
	# assign positions
	for i in range(len(slots)):
		slots[i].position = Vector2(x + i * (Constants.HAND_SLOTS_GAP + slotSize.x), y)


func get_first_empty_slot() -> Sprite2D:
	for slot in slots:
		if slot.card == null: return slot
	return null
