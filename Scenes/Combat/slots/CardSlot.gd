extends Sprite2D
class_name CardSlot

enum Type {
	SELECTION,
	HAND
}

@export var type:Type

var card:Card = null
