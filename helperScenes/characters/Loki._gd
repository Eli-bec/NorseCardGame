extends Character


var sword = preload("res://helperScenes/cards/sword.tscn")
var shield = preload("res://helperScenes/cards/shield.tscn")
var shapeshift = preload("res://helperScenes/cards/shapeshift.tscn")


func _ready():
	characterName = "Loki"


func play_cards() -> Array:
	return [shapeshift.instantiate(), sword.instantiate(), shield.instantiate()]
