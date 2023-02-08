extends Character

func _ready():
	$Deck.cardCounts = {
		Global.CARDS["sword"]: 5,
		Global.CARDS["shield"]: 5,
		Global.CARDS["dodge"]: 5
	}
	hp = 10

func draw_card() -> Card:
	return $Deck.draw_card()
