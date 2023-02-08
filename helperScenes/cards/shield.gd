extends Card

func resolve(character:Character):
	if not enhanced:
		character.add_effect('block', [2])
	else:
		character.add_effect('block', [4])
