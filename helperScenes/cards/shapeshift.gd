extends Card

func resolve(character:Character):
	if enhanced:
		character.add_effect('shapeshift', [0, 1])
	else:
		character.add_effect('shapeshift', [1])
