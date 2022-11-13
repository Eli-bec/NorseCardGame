extends Node

@onready var slots:Array[Node] = [$CardSlot1, $CardSlot2, $CardSlot3]

func _ready():
	print(slots)

func get_top_empty_slot() -> Node:
	for i in range(Constants.NUMBER_OF_CARD_SELECTION):
		if slots[i].card == null: return slots[i]
	return null

func reveal_cards():
	for slot in slots:
		if slot.card: slot.card.revealed = true
