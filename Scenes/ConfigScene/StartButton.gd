extends Button


func _on_pressed():
	print('Configurations')
	print("Enemy's deck ratio: ", Config.enemy_deck_ratio)
	print("Player's deck ratio: ", Config.player_deck_ratio)
	get_tree().change_scene_to_packed(Constants.COMBAT_SCENE)
