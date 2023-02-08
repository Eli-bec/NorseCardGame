class_name CharacterDisplay
extends Sprite2D

@export var nameLabel:Label
@export var hpLabel:Label

var effects:Dictionary = {}

var characterName:String :
	set(value):
		characterName = value
		nameLabel.text = value

var maxHP:int

func set_hp(value:int):
	hpLabel.text = "HP: %d/%d" % [value, maxHP]

func init(Name:String, hp:int, maxHp:int):
	characterName = Name
	maxHP = maxHp
	set_hp(hp)
