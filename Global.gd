extends Node

enum CardType {
	DEFAULT,
	ATTACK,
	DEFEND,
	SKILL
}

var COLORS = [
	Color.BLACK,
	Color.RED,
	Color.BLUE,
	Color.GREEN
]

var CARDS = {
	"sword" = preload("res://helperScenes/cards/sword.tscn"),
	"dodge" = preload("res://helperScenes/cards/dodge.tscn"),
	"shapeshift" = preload("res://helperScenes/cards/shapeshift.tscn"),
	"shield" = preload("res://helperScenes/cards/shield.tscn"),
}

var COUNTERED_TYPE = {
	CardType.DEFEND: CardType.ATTACK,
	CardType.ATTACK: CardType.SKILL,
	CardType.SKILL: CardType.DEFEND,
}

var RNG = RandomNumberGenerator.new()
var pause:bool = false

var veil_visible:bool = true

signal input_suppression_changed(value)
var suppress_input:bool = false :
	set(value):
		suppress_input = value
		emit_signal('input_suppression_changed', value)

func Instantiate(scene:PackedScene, parent:Node = null) -> Node:
	var node = scene.instantiate()
	if parent == null:
		parent = get_tree().get_root()
	parent.add_child(node)
	return node
