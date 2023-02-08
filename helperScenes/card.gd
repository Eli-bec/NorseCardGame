class_name Card
extends Sprite2D


enum Target {
	NONE,
	SELF,
	OPPONENT
}

@export var cardName:String = ""
@export var type:Global.CardType
@export var target:Target

#@export var effectNames:Array[String]
#@export var effectValues:Array[float]
#@export var effectVariations:Array[int]
#@export var enhancedValues:Array[float]
#@export var enhancedVariations:Array[int]

@onready var enhancement_des_label = $display/Enhancement_Label
@onready var description_label = $display/Description_Label

var enhanced:bool = false : set = set_enhancement

var slot:Slot

func _ready():
	if cardName != "":
		name = "Card_%s" % cardName


func set_enhancement(value:bool):
	if enhanced == value: return
	enhanced = value
	enhancement_des_label.visible = enhanced
	description_label.visible = not enhanced

func resolve(target:Character):
	pass
