extends Node

@export var packedCards:Array[PackedScene]
@export var cardProportions:Array[int]

var rng = RandomNumberGenerator.new()

func _ready():
	$player.init("Player", 10, 10)
	$enemy.init("Heimdall", 12, 12)
	deal_cards()


func _on_card_clicked(card:Card):
	pass


# deal cards until hand is full
func deal_cards():
	var card
	for slot in $Hand.get_children():
		card = random_card()
		slot.cards.append(card)
		card.position = slot.global_position


# get a new instance of a random card
# the instance is added to the scene tree
func random_card() -> Card:
	var packedCard = packedCards[rng.randi_range(0, packedCards.size() - 1)]
	var card = packedCard.instantiate()
	get_tree().get_root().add_child.call_deferred(card)
	return card
