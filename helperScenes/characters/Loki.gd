extends Character

signal mid_battle_dialogue
var mid_dialogue_triggerred = false
signal defeat_dialogue

func _ready():
	$Deck.cardCounts = {
		Global.CARDS["sword"]: 5,
		Global.CARDS["shield"]: 5,
		Global.CARDS["shapeshift"]: 5
	}
	hp = 14

func select_cards(playerField, thisField) -> Array[Card]:
	var cards = []
	for slot in thisField.get_children():
		print(slot, ' ', slot.enhancerType)
		if slot.enhancerType == Global.CardType.ATTACK:
			cards.append(Global.Instantiate(Global.CARDS["sword"]))
		elif slot.enhancerType == Global.CardType.DEFEND:
			cards.append(Global.Instantiate(Global.CARDS["shield"]))
		elif slot.enhancerType == Global.CardType.SKILL:
			cards.append(Global.Instantiate(Global.CARDS["shapeshift"]))
		else:
			print('randomized')
			cards.append(Global.Instantiate($Deck.random_card()))
	print(cards)
	return cards


func _on_hp_change(_Hp):
	if hp <= 0:
		emit_signal('defeat_dialogue')
	elif not mid_dialogue_triggerred and hp <= 7:
		mid_dialogue_triggerred = true
		emit_signal('mid_battle_dialogue')
