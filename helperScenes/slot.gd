class_name Slot
extends Sprite2D

@export var enhancerType:Global.CardType = Global.CardType.DEFAULT

@export var enhancerSprites:Array[Texture2D]

var cards:Array

func _ready():
	texture = enhancerSprites[enhancerType]
