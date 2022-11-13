extends ScrollContainer

@export var des_label:Label

@export var enemyDeckRatio:HBoxContainer
@export var playerDeckRatio:HBoxContainer
@export var showEnemyCardplays:CheckButton
@export var playerHP:SpinBox
@export var enemyHP:SpinBox


# set values to previous
func _ready():
	enemyDeckRatio.value = Config.enemy_deck_ratio
	playerDeckRatio.value = Config.player_deck_ratio
	showEnemyCardplays.set_pressed_no_signal(Config.show_enemy_cardplays)
	playerHP.value = Config.player_hp
	enemyHP.value = Config.enemy_hp


func _on_enemy_deck_ratio_input_value_changed(value):
	Config.enemy_deck_ratio = value


func _on_player_deck_ratio_input_value_changed(value):
	Config.player_deck_ratio = value


func _on_player_hp_input_value_changed(value):
	Config.player_hp = value


func _on_enemy_hp_input_value_changed(value):
	Config.enemy_hp = value
