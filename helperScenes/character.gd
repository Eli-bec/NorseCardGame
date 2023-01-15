class_name Character
extends Sprite2D

@export var nameLabel:Label
@export var hpLabel:Label

var characterName:String :
	set(value):
		characterName = value
		nameLabel.text = value

var HP:int
var maxHP:int

func set_hp(value:int = -1, maxHp:int = 0):
	if HP >= 0: HP = value
	if maxHp > 0: maxHP = maxHp
	hpLabel.text = "HP: %d/%d" % [HP, maxHP]

func init(Name:String, hp:int, maxHp:int):
	characterName = Name
	set_hp(hp, maxHp)
