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

var suppress_input:bool = false
