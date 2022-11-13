extends Node

var tween:Tween
var rng = RandomNumberGenerator.new()

func _ready():
	$Enemy/Deck.ratio = Config.enemy_deck_ratio
	$Player/Deck.ratio = Config.player_deck_ratio
	new_turn()

# deal cards to player
func deal_cards():
	tween = get_tree().create_tween()
	for slot in $Player/Hand.slots:
		if slot.card == null:
			deal_card(slot)

# deal a card to the specified slot
func deal_card(slot:Sprite2D):
	var packedCard = $Player/Deck.pop_random_card()
	# add card instance to scene
	slot.card = packedCard.instantiate()
	slot.card.slot = slot
	$Player/Cards.add_child(slot.card) # add card as a child of 'Cards' for easily management
	# connect to the card's click signal
	slot.card.clicked.connect(_on_card_clicked)
	# setup card deal animation
	slot.card.position = $HUD/GameUI/DrawPileButton.position
	slot.card.scale = slot.scale
	tween.tween_callback(set_visible.bind(slot.card))
	tween.tween_property(slot.card, 'position', slot.position, Constants.DEAL_CARD_ANIMATION_DURATION)
	tween.tween_callback(slot.card.set_input)

func move_card(card, dest_slot, enable_input:bool = true):
	print('moving card')
	# card tween animation
	if not tween.is_valid(): tween = get_tree().create_tween()
	tween.tween_callback(set_visible.bind(card))
	tween.tween_property(card, 'position', dest_slot.position, Constants.PLAY_CARD_ANIMATION_DURATION)
	if card.slot and card.slot.type != dest_slot.type:
		print('scaling')
		tween.parallel()\
			.tween_property(card, 'scale', dest_slot.scale, Constants.PLAY_CARD_ANIMATION_DURATION)
	# enable input after the tween
	tween.tween_callback(card.set_input)
	# reassign card to destinated slot
	if card.slot: card.slot.card = null
	card.slot = dest_slot
	dest_slot.card = card

# return the result of two cards crashing together
# return
#   0: draw
#   1: player won
#  -1: play lost
func card_crash_result(pCard, eCard) -> int:
	# handle not enough cards played
	if pCard == null or eCard == null:
		return int(eCard == null) - int(pCard == null)
	if pCard.type == eCard.type: return 0
	if Constants.counter_table[pCard.type] == eCard.type: return 1
	return -1

func obj_queue_free(obj:Object):
	if obj: obj.queue_free()

# a callback to make sure all tweening objects are visible
func set_visible(node:Node, value:bool = true):
	if 'visible' in node: node.visible = value

func new_turn():
	Global.input = true
	deal_cards()
	$Enemy.play_cards()

func end(won:bool):
	$HUD/EndingScreen.visible = true
	if won:
		$HUD/EndingScreen/VBoxContainer/EndingLabel.text = "You won"
	else:
		$HUD/EndingScreen/VBoxContainer/EndingLabel.text = "You lost"
	# stop all animations
	if tween.is_running(): tween.kill()
	# disable all gameplay-related buttons
	$HUD/GameUI/DrawPileButton.disabled = true
	$HUD/GameUI/ComfirmButton.disabled = true

func _on_card_clicked(orig_slot:Sprite2D):
	print("card clicked")
	var goal_slot
	if orig_slot.type == CardSlot.Type.HAND:
		goal_slot = $Player/CardSlots.get_top_empty_slot()
	elif orig_slot.type == CardSlot.Type.SELECTION:
		goal_slot = $Player/Hand.get_first_empty_slot()
	if goal_slot:
		var card = orig_slot.card
		print('Start tweening...')
		# disable input for the duration of the tween
		card.input = false
		# tween the card to new position
		tween = get_tree().create_tween()
		tween.tween_property(card, 'position', goal_slot.position, Constants.PLAY_CARD_ANIMATION_DURATION)
		tween.parallel()\
			.tween_property(card, 'scale', goal_slot.scale, Constants.PLAY_CARD_ANIMATION_DURATION)
		tween.tween_callback(card.set_input)
		# assign the card to the new slot
		orig_slot.card = null
		goal_slot.card = card
		card.slot = goal_slot

# Combat Logics
func _on_comfirm_button_pressed():
	print('comfirm')
	$Enemy/CardSlots.reveal_cards()
	var result = 0; var crash_result
	var pCard; var eCard; var pointer
	tween = get_tree().create_tween()
	# disable all inputs
	Global.input = false
	tween.tween_interval(Constants.CARD_CRASH_DELAY) # add delay to let the player look at the results
	for i in range(Constants.NUMBER_OF_CARD_SELECTION):
		pCard = $Player/CardSlots.slots[i].card
		eCard = $Enemy/CardSlots.slots[i].card
		pointer = $Pointers.pointers[i]
		# show pointer
		pointer.visible = true
		# reveal enemy's card
		eCard.revealed = true
		# empty slots
		$Player/CardSlots.slots[i].card = null
		$Enemy/CardSlots.slots[i].card = null
		# evaluate card crash result
		crash_result = card_crash_result(pCard, eCard)
		if crash_result == 0:
			pointer.frame = 1
		else:
			pointer.frame = 0
			pointer.rotation = PI / 2 * crash_result # point to the loser
		result += crash_result
		# crash animation
		if i:
			# add delay between card crashes
			tween.tween_interval(Constants.CARD_CRASH_INTERVAL)
		if pCard:
			tween.tween_property(pCard, 'position', pointer.position, Constants.CARD_CRASH_ANIMATION_DURATION)
			tween.parallel()\
				.tween_property(pCard, 'scale', Vector2(0, 0), Constants.CARD_CRASH_ANIMATION_DURATION)
			tween.parallel()
		if eCard:
			tween.tween_property(eCard, 'position', pointer.position, Constants.CARD_CRASH_ANIMATION_DURATION)
			tween.parallel()\
				.tween_property(eCard, 'scale', Vector2(0, 0), Constants.CARD_CRASH_ANIMATION_DURATION)
		# free the cards after the animation
		tween.tween_callback(obj_queue_free.bind(pCard))
		tween.tween_callback(obj_queue_free.bind(eCard))
	# set big pointer direction
	if result < 0: $Pointers/BigPointer.rotation = -PI/2
	elif result > 0: $Pointers/BigPointer.rotation = PI/2
	# merge into a big pointer animations
	tween.tween_property($Pointers/Pointer1, 'position', $Pointers/BigPointer.position,
		Constants.POINTERS_MERGE_ANIMATION_DURATION)
	tween.parallel()\
		.tween_property($Pointers/Pointer3, 'position', $Pointers/BigPointer.position,
			Constants.POINTERS_MERGE_ANIMATION_DURATION)
	tween.tween_callback(set_visible.bind($Pointers/BigPointer))
	tween.tween_callback($Pointers.reset_small_pointers)
	if result < 0:
		tween.tween_property($Pointers/BigPointer, 'position', $Player.position,
			Constants.POINTER_TOWARD_LOSER_ANIMATION_DURATION)
		tween.tween_callback(set_visible.bind($Pointers/BigPointer, false))
		tween.tween_callback($Player.take_damage)
	elif result > 0:
		tween.tween_property($Pointers/BigPointer, 'position', $Enemy.position,
			Constants.POINTER_TOWARD_LOSER_ANIMATION_DURATION)
		tween.tween_callback(set_visible.bind($Pointers/BigPointer, false))
		tween.tween_callback($Enemy.take_damage)
	tween.tween_callback($Pointers.reset_big_pointer)
	tween.tween_callback(new_turn)


func _on_player_defeated(): end(false)
func _on_enemy_defeated(): end(true)
