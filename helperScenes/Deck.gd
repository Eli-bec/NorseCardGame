class_name Deck
extends Node

var infinite:bool = false

var cardCounts:Dictionary

func random_card() -> PackedScene:
	var total = Util.sum(cardCounts.values())
	var num = Global.RNG.randf()
	for card in cardCounts:
		var portion = cardCounts[card] / total
		if num <= portion:
			return card
		num -= portion
	return cardCounts.keys()[0]

func draw_card() -> Card:
	return Global.Instantiate(random_card())

func discard(card:Card):
	card.queue_free()
