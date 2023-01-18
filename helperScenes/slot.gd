class_name Slot
extends Sprite2D

enum SlotType {
	DEFAULT,
	PLAYER,
	ENEMY,
	HAND
}

signal clicked(slot:Slot)

@export var enhancerType:Globals.CardType = Globals.CardType.DEFAULT
@export var slotType:SlotType = SlotType.DEFAULT
@export var capacity:int = 1

@export var enhancerSprites:Array[Texture2D]

var cards:Array


func _ready():
	texture = enhancerSprites[enhancerType]


func _unhandled_input(event):
	if (
		not Globals.suppress_input and
		event is InputEventMouseButton and
		event.button_index == MOUSE_BUTTON_LEFT and
		event.pressed and
		get_rect().has_point(get_local_mouse_position())
	):
		emit_signal("clicked", self)


func full() -> bool:
	return cards.size() >= capacity
