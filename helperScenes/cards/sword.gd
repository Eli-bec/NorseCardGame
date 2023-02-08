extends Card

func resolve(character:Character):
	if not enhanced:
		character.damage(2)
	else:
		character.damage(4)
