extends Character

@export var CombatController:Node

var rng = RandomNumberGenerator.new()

func play_cards():
	var card; var packedCard
	for i in range(Constants.NUMBER_OF_CARD_SELECTION):
		packedCard = $Deck.pop_random_card()
		card = packedCard.instantiate()
		card.visible = false
		card.position = position
		card.input = false
		if not Config.show_enemy_cardplays: card.revealed = false
		$Cards.add_child(card)
		CombatController.move_card(card, $CardSlots.get_top_empty_slot(), false)
