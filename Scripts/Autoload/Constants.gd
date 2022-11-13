extends Node

# Visuals
var HAND_SLOTS_GAP = 20
var INHAND_CARDS_SCALE = Vector2(.25, .25)
var SELECTED_CARDS_SCALE = Vector2(.2, .2)

# Animation
var DEAL_CARD_ANIMATION_DURATION = .2
var PLAY_CARD_ANIMATION_DURATION = .2
var CARD_CRASH_ANIMATION_DURATION = .2
var CARD_CRASH_INTERVAL = .5
var CARD_CRASH_DELAY = 1.5
var POINTERS_MERGE_ANIMATION_DURATION = 1
var POINTER_TOWARD_LOSER_ANIMATION_DURATION = .5

# Gameplay
var NUMBER_OF_CARD_SELECTION = 3
var counter_table:Dictionary = {
	Card.Type.ATTACK: Card.Type.MANEUVER,
	Card.Type.DEFEND: Card.Type.ATTACK,
	Card.Type.MANEUVER: Card.Type.DEFEND
}

# Scene
var COMBAT_SCENE = load("res://Scenes/Combat.tscn")
var CONFIG_SCENE = load("res://Scenes/Config.tscn")
