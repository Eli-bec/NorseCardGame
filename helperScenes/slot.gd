class_name Slot
extends Sprite2D

enum SlotType {
	DEFAULT,
	PLAYER,
	ENEMY,
	HAND
}

signal clicked(slot:Slot)

@export var enhancerType:Global.CardType = Global.CardType.DEFAULT
@export var slotType:SlotType = SlotType.DEFAULT
@export var capacity:int = 1

@export var enhancerSprites:Array[Texture2D]

var card:Card = null


func _ready():
	update_texture()


func update_texture():
	texture = enhancerSprites[enhancerType]


func _unhandled_input(event):
	if (
		not Global.suppress_input and
		event is InputEventMouseButton and
		event.button_index == MOUSE_BUTTON_LEFT and
		event.pressed and
		get_rect().has_point(get_local_mouse_position())
	):
		emit_signal("clicked", self)

func is_empty() -> bool:
	return card == null
