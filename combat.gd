extends Node2D

signal new_turn

########## Visuals ##########
@onready var veils = [
	$EnemyField/Slot1/Veil1,
	$EnemyField/Slot2/Veil2,
	$EnemyField/Slot3/Veil3]
@export var playerDisplay:Node2D
@export var enemyDisplay:Node2D
@export var midDialogue:Control
@export var endDialogue:Control

########## Initializations ##########
func _ready():
	for slot in $PlayerField.get_children() + $Hand.get_children():
		slot.clicked.connect(_on_slot_clicked)
	$player.hp_change.connect(playerDisplay.set_hp)
	$enemy.hp_change.connect(enemyDisplay.set_hp)
	Global.input_suppression_changed.connect(_on_input_suppresssion_changed)


########## helpers ##########
func set_card_to_slot(card:Card, slot:Slot):
	if slot.card != null:
		detach_card_from_slot(slot)
	if card.slot != null:
		detach_card_from_slot(card.slot)
	card.slot = slot
	slot.card = card
	card.global_position = slot.global_position
	card.enhanced = card.type == slot.enhancerType

func detach_card_from_slot(slot:Slot) -> Card:
	if slot.card == null: return
	var card = slot.card
	card.slot = null
	slot.card = null
	card.enhanced = false
	return card


########## Game process ##########
func player_draw_cards():
	for slot in $Hand.get_children():
		if slot.is_empty():
			var card = $player.draw_card()
			set_card_to_slot(card, slot)

func enemy_play_cards():
	var cards = $enemy.select_cards($PlayerField, $EnemyField)
	for i in range(3):
		var slot = $EnemyField.get_child(i)
		set_card_to_slot(cards[i], slot)


func resolve_row(player_slot:Slot, enemy_slot:Slot) -> Tween:
	var tween = get_tree().create_tween()
	tween.stop()
	var player_card = player_slot.card
	var enemy_card = enemy_slot.card
	resolve_countering(tween, player_slot, enemy_slot)
	if player_card != null: tween_to_affected(tween, player_card, true)
	if enemy_card != null: tween_to_affected(tween, enemy_card, false)
	tween.chain()
	player_card = player_slot.card
	enemy_card = enemy_slot.card
	if player_card != null and get_card_target(player_card, true) != null:
		tween.tween_callback(player_card.resolve.bind(get_card_target(player_card, true)))
		tween.tween_callback(discard.bind($player, player_card))
	if enemy_card != null and get_card_target(enemy_card, false) != null:
		tween.tween_callback(enemy_card.resolve.bind(get_card_target(enemy_card, false)))
		tween.tween_callback(discard.bind($enemy, enemy_card))
	return tween

func resolve_countering(tween:Tween, player_slot, enemy_slot):
	if player_slot.card == null or enemy_slot.card == null: return
	if (
		player_slot.card.type == Global.CardType.DEFAULT or 
		enemy_slot.card.type == Global.CardType.DEFAULT): return
	anim_slots_smash(tween, player_slot, enemy_slot)
	if player_slot.card.type == Global.COUNTERED_TYPE[enemy_slot.card.type]:
		anim_card_fade(tween, player_slot.card, true)
		anim_card_recenter(tween, enemy_slot.card)
		tween.chain().tween_callback(discard.bind($player, player_slot.card))
		detach_card_from_slot(player_slot)
	elif enemy_slot.card.type == Global.COUNTERED_TYPE[player_slot.card.type]:
		anim_card_fade(tween, enemy_slot.card, false)
		anim_card_recenter(tween, player_slot.card)
		tween.chain().tween_callback(discard.bind($enemy, enemy_slot.card))
		detach_card_from_slot(enemy_slot)
	else:
		anim_card_recenter(tween, player_slot.card)
		anim_card_recenter(tween, enemy_slot.card)
	tween.chain()
	tween.tween_interval(.5)

func discard(character, card):
	if card.slot != null: detach_card_from_slot(card.slot)
	character.discard(card)

func tween_to_affected(tween:Tween, card, is_players:bool):
	if card.target == Card.Target.NONE:
		tween\
			.tween_property(card, "modulate", card.modulate * Color(1, 1, 1, 0), .3)
		tween\
			.parallel()\
			.tween_property(card, "scale", Vector2(1.5, 1.5), .3)
		tween.parallel()
		return
	var target = get_card_target_display(card, is_players)
	tween.tween_property(card, "global_position", target.global_position, .5)
	tween.parallel()

func get_card_target_display(card, is_players:bool):
	var target
	if is_players:
		if card.target == Card.Target.SELF:
			target = playerDisplay
		elif card.target == Card.Target.OPPONENT:
			target = enemyDisplay
	else:
		if card.target == Card.Target.OPPONENT:
			target = playerDisplay
		elif card.target == Card.Target.SELF:
			target = enemyDisplay
	return target

func get_card_target(card, is_players:bool):
	var target
	if is_players:
		if card.target == Card.Target.SELF:
			target = $player
		elif card.target == Card.Target.OPPONENT:
			target = $enemy
	else:
		if card.target == Card.Target.OPPONENT:
			target = $player
		elif card.target == Card.Target.SELF:
			target = $enemy
	return target

########## Animations ##########
func anim_slots_smash(tween, player_slot, enemy_slot):
	var card = player_slot.card
	tween\
		.tween_property(card, "position", card.position + Vector2(35, 0), .1)
	tween.parallel()
	card = enemy_slot.card
	tween\
		.tween_property(card, "position", card.position - Vector2(35, 0), .1)
	tween.parallel()
	tween.chain()

func anim_card_fade(tween, card, is_players:bool):
	if is_players:
		tween\
			.tween_property(card, "position", card.position - Vector2(70, 0), .5)
	else:
		tween\
			.tween_property(card, "position", card.position + Vector2(70, 0), .5)
	tween\
		.parallel()\
		.tween_property(card, "modulate", card.modulate * Color(1, 1, 1, 0), .5)
	tween.parallel()

func anim_card_recenter(tween, card):
	tween\
		.tween_property(card, "position", card.position, .3)
	tween.parallel()

########## Signal callbacks ##########
func _on_game_start_combat():
	visible = true
	emit_signal("new_turn")


func _on_new_turn():
	if Global.veil_visible:
		for veil in veils:
			veil.visible = true
	Global.suppress_input = false
	
	player_draw_cards()
	
	for slot in $PlayerField.get_children() + $EnemyField.get_children():
		if Global.RNG.randi_range(0, 2) == 0:
			slot.enhancerType = Global.CardType.DEFAULT
		else:
			var n = Global.RNG.randi_range(0, 2)
			if n == 0:
				slot.enhancerType = Global.CardType.ATTACK
			elif n == 1:
				slot.enhancerType = Global.CardType.DEFEND
			else:
				slot.enhancerType = Global.CardType.SKILL
		slot.update_texture()
	enemy_play_cards()


func _on_slot_clicked(slot:Slot):
	if slot.card == null:
		pass
	else:
		var empty_slot
		if slot.slotType == Slot.SlotType.HAND:
			empty_slot = $PlayerField.get_empty_slot()
		elif slot.slotType == Slot.SlotType.PLAYER:
			empty_slot = $Hand.get_empty_slot()
		if empty_slot == null: return
		set_card_to_slot(slot.card, empty_slot)


func _on_end_turn_button_pressed():
	print("combat started")
	Global.suppress_input = true
	for veil in veils:
		veil.visible = false

	var tweens:Array[Tween] = [get_tree().create_tween()]
	tweens[0].tween_interval(1) # start delay
	for i in range(3):
		tweens.append(
			resolve_row($PlayerField.get_child(i), $EnemyField.get_child(i)))
	for i in range(3):
		tweens[i].chain().tween_callback(tweens[i+1].play)
	tweens[3].tween_callback(emit_signal.bind("new_turn"))
	tweens[0].play()


func _on_enemy_mid_battle_dialogue():
	midDialogue.show_sequence()


func _on_enemy_defeat_dialogue():
	endDialogue.show_sequence()

func _on_input_suppresssion_changed(value):
	$MarginContainer/EndTurnButton.disabled = value


func _on_veil_toggle_pressed():
	Global.veil_visible = false
	for veil in veils:
		veil.visible = false
	$MarginContainer/veilToggle.disabled = true
