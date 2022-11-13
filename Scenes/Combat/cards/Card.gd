extends Node2D
class_name Card

enum Type {
	ATTACK,
	DEFEND,
	MANEUVER
}

@export var Name:String = ''
@export var type:Type
@export var effect:String = '' # name to access global functions

var input:bool = false # disable input
func set_input(value:bool = true): input = value

var slot:Sprite2D
var revealed:bool = true :
	get:
		return revealed
	set(value):
		revealed = value
		$Back.visible = not revealed

signal clicked(slot:Sprite2D)

func _on_area_2d_input_event(viewport, event, shape_idx):
	if not input or not Global.input: return
	if event is InputEventMouseButton and event.pressed:
		emit_signal('clicked', slot)
