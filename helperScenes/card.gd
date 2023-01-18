class_name Card
extends Sprite2D


enum Target {
	NONE,
	SELF,
	OPPONENT
}

@export var cardName:String = ""
@export var type:Globals.CardType
@export var target:Target

@export var effects:Array[String]
@export var effectValues:Array[float]
@export var enhancedValues:Array[float]

@onready var enhancement_des_label = $display/Enhancement_Label
@onready var description_label = $display/Description_Label

var enhanced:bool = false


func _ready():
	if cardName != "":
		name = "Card_%s" % cardName


func set_enhancement(value:bool):
	if enhanced == value: return
	enhanced = value
	enhancement_des_label.visible = enhanced
	description_label.visible = not enhanced

#func _unhandled_input(event):
#	if (
#		not Globals.suppress_input and 
#		event is InputEventMouseButton and
#		event.button_index == MOUSE_BUTTON_LEFT and 
#		event.is_action_pressed("click") and 
#		get_rect().has_point(get_local_mouse_position())
#	):
#		print($display/Name_Label.text)
#		emit_signal("clicked", self)
