extends Card

func resolve(character:Character):
	if enhanced:
		character.add_effect('dodge', [0, 1])
	else:
		character.add_effect("dodge", [1])
