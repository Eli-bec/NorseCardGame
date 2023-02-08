#class_name CharacterDisplay
extends Sprite2D

@export var nameLabel:Label
@export var hpLabel:Label

var effects:Dictionary = {}

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

func reduce_hp(amount:int):
	set_hp(HP - amount)

func init(Name:String, hp:int, maxHp:int):
	characterName = Name
	set_hp(hp, maxHp)

func play_cards() -> Array:
	return []

func draw_cards() -> Array[Card]:
	return []
