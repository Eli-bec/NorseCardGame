class_name Card
extends Sprite2D

signal clicked(card)

@export var type:Global.CardType

func _unhandled_input(event):
	if (
		not Global.suppress_input and 
		event is InputEventMouseButton and
		event.button_index == MOUSE_BUTTON_LEFT and 
		event.is_action_pressed("click")
	):
		print("clicked")
		emit_signal("clicked", self)
