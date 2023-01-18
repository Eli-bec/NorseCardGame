extends Node

@export var packedCards:Array[PackedScene]
@export var cardProportions:Array[int]

@onready var veils = [
	$EnemyField/Slot1/Veil1,
	$EnemyField/Slot2/Veil2,
	$EnemyField/Slot3/Veil3
]
@onready var portion_button = $MarginContainer/PortionButton
@onready var end_turn_button = $MarginContainer/EndTurnButton

var rng = RandomNumberGenerator.new()

var selectedSlot:Slot = null

func _ready():
	$player.init("Player", 10, 10)
	$enemy.init("Loki", 12, 12)
	deal_cards()
	enemy_play_cards()


# deal cards until hand is full
func deal_cards():
	var card
	for slot in $Hand.get_children():
		if slot.full(): continue
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


# move `card` from `orig` to `dest`
# return value is a boolean indicating if the translation is successful
func move_card(card:Card, dest:Slot) -> bool:
	# if destination is full
	if dest.cards.size() == dest.capacity: return false
	dest.cards.append(card)
	card.global_position = dest.global_position
#	print(card)
#	print(card.type, ' ', dest.enhancerType)
	card.set_enhancement(card.type == dest.enhancerType)
	return true


func _on_slot_clicked(slot:Slot):
	if slot.cards.size() != 0:
		var card = slot.cards.pop_back()
		var dest
		if selectedSlot != null:
			dest = selectedSlot
		elif slot.slotType == Slot.SlotType.PLAYER:
			dest = $Hand.get_empty_slot()
		elif slot.slotType == Slot.SlotType.HAND:
			dest = $PlayerField.get_empty_slot()
		if dest != null: move_card(card, dest)
		selectedSlot = null
		$SelectFrame.visible = false
	else:
		selectedSlot = slot
		$SelectFrame.global_position = slot.global_position
		$SelectFrame.visible = true


# combat logics here
func _on_end_turn_button_pressed():
	print("combat started")
	set_input_suppression(true)
	for veil in veils:
		veil.visible = false
	
	var tweens:Array[Tween] = []
	for i in range(3):
		tweens.append(
			evaluate_row($PlayerField.get_child(i), $EnemyField.get_child(i)))
	print(tweens)
	for i in range(2):
		tweens[i].chain().tween_callback(tweens[i+1].play)
	tweens[2].tween_callback(new_turn)
	tweens[0].play()
	resolve_end_turn_effects($player)
	resolve_end_turn_effects($enemy)

func new_turn():
	print("new turn")
	set_input_suppression(false)
	for veil in veils:
		veil.visible = true
	for slot in $PlayerField.get_children() + $EnemyField.get_children():
		slot.cards.clear()
	enemy_play_cards()
	deal_cards()
	print($player.effects)

# evaluate the result of the row and return a stopped tween that contains its
# animations
func evaluate_row(player_slot, enemy_slot) -> Tween:
	var tween = get_tree().create_tween()
	tween.stop()
	var concat_cards = player_slot.cards + enemy_slot.cards
	# card countering
	if (player_slot.cards.size() != 0 and
		enemy_slot.cards.size() != 0
	):
		anim_slots_smash(tween, player_slot, enemy_slot)
		var player_countered = []
		for card in enemy_slot.cards:
			player_countered.append(get_countered_type(card.type))
		var enemy_countered = []
		for card in player_slot.cards:
			enemy_countered.append(get_countered_type(card.type))
		# countered cards animations (bouce back & fade out)
		for card in player_slot.cards:
			if card.type in player_countered:
				anim_card_fade(tween, card, true)
				player_slot.cards.remove_at(player_slot.cards.find(card))
			else:
				anim_card_recenter(tween, card)
		for card in enemy_slot.cards:
			if card.type in enemy_countered:
				anim_card_fade(tween, card, false)
				enemy_slot.cards.remove_at(enemy_slot.cards.find(card))
			else:
				anim_card_recenter(tween, card)
		tween.chain()
	tween.tween_interval(.5)
	# move card to affected character
	for card in player_slot.cards:
		tween_to_affected(tween, card, true)
	for card in enemy_slot.cards:
		tween_to_affected(tween, card, false)
	tween.chain()
	# evaluate card effects
	for card in player_slot.cards:
		var target = get_card_target(card, true)
		print(card, card.enhanced)
		apply_effects(target, card)
#	print("player effects: ", $player.effects)
	for card in enemy_slot.cards:
		var target = get_card_target(card, false)
		apply_effects(target, card)
#	print("enemy effects: ", $enemy.effects)
	# resolve the effects
	tween.tween_callback($player.reduce_hp.bind(resolve_damages($player)))
	tween.tween_callback($enemy.reduce_hp.bind(resolve_damages($enemy)))
	# queue free evaluated cards
	for card in concat_cards:
		tween.tween_callback(card.queue_free)
	tween.tween_callback(check_termination.bind(tween))
	return tween

func check_termination(tween:Tween):
	if $player.HP == 0 or $enemy.HP == 0:
		tween.stop()

func resolve_damages(target:Character):
	if "damage" not in target.effects: return 0
	var total_damage = 0
	for di in range(target.effects["damage"].size()):
		var damage = target.effects["damage"][di]
		var evaded = false
		if "dodge" in target.effects:
			for i in range(target.effects["dodge"].size()):
				if target.effects["dodge"][i] > 0:
					target.effects["dodge"][i] -= 1
					evaded = true
					break
		if evaded: continue
		if "shapeshift" in target.effects:
			for i in range(target.effects["shapeshift"].size()):
				if target.effects["shapeshift"][i] > 0:
					evaded = true
					return 0
		if evaded: continue
		if "block" in target.effects:
			for i in range(target.effects["block"].size()):
				if target.effects["block"][i] >= damage:
					target.effects["block"][i] -= damage
					damage = 0
					break
				else:
					damage -= target.effects["block"][i]
					target.effects["block"][i] = 0
		total_damage += damage
		target.effects["damage"][di] = 0
	return total_damage

func resolve_end_turn_effects(target:Character):
	# block: remove completely
	if "block" in target.effects:
		target.effects.erase("block")
	if "dodge" in target.effects:
		if target.effects["dodge"].size() > 1:
			target.effects["dodge"].pop_front()
		else:
			target.effects["dodge"] = [0]
	if "shapeshift" in target.effects:
		if target.effects["shapeshift"].size() > 1:
			target.effects["shapeshift"].pop_front()
		else:
			target.effects["shapeshift"] = [0]

func apply_effects(target:Character, card:Card):
	for effect_name in card.effects:
#		print(target.effects)
		var amount
		if card.enhanced:
			amount = card.enhancedValues[card.effects.find(effect_name)]
		else:
			amount = card.effectValues[card.effects.find(effect_name)]
		if amount == 0: continue
		var effect_info = effect_name.split('_')
		if effect_info.size() == 1:
			if effect_name not in target.effects:
				target.effects[effect_name] = [0]
			target.effects[effect_name][0] += amount
		elif effect_info.size() == 2:
			var base_effect_name = effect_info[0]
			var effect_variant = int(effect_info[1])
			if base_effect_name not in target.effects:
				target.effects[base_effect_name] = [0]
			if target.effects[base_effect_name].size() < effect_variant:
				target.effects[base_effect_name].resize(effect_variant)
				for i in range(effect_variant):
					if target.effects[base_effect_name][i] == null:
						target.effects[base_effect_name][i] = 0
			target.effects[base_effect_name][effect_variant-1] += amount

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

# tween card to affected character
func tween_to_affected(tween:Tween, card, is_players:bool):
	if card.target == Card.Target.NONE:
		tween\
			.tween_property(card, "modulate", card.modulate * Color(1, 1, 1, 0), .3)
		tween\
			.parallel()\
			.tween_property(card, "scale", Vector2(1.5, 1.5), .3)
		tween.parallel()
		return
	var target = get_card_target(card, is_players)
	tween.tween_property(card, "global_position", target.global_position, .5)
	tween.parallel()

# card smashing animation
func anim_slots_smash(tween, player_slot, enemy_slot):
	for card in player_slot.cards:
		tween\
			.tween_property(card, "position", card.position + Vector2(35, 0), .1)
		tween.parallel()
	for card in enemy_slot.cards:
		tween\
			.tween_property(card, "position", card.position - Vector2(35, 0), .1)
		tween.parallel()
	tween.chain()

func anim_card_recenter(tween, card):
	tween\
		.tween_property(card, "position", card.position, .3)
	tween.parallel()

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


func get_countered_type(type:Globals.CardType) -> int:
	if type == Globals.CardType.DEFEND:
		return Globals.CardType.ATTACK
	if type == Globals.CardType.ATTACK:
		return Globals.CardType.SKILL
	if type == Globals.CardType.SKILL:
		return Globals.CardType.DEFEND
	return -1


func set_input_suppression(value:bool):
	Globals.suppress_input = value
	portion_button.disabled = value
	end_turn_button.disabled = value


func enemy_play_cards():
	var cards = $enemy.play_cards()
	for i in range(3):
		if cards[i] == null: continue
		add_child(cards[i])
		move_card(cards[i], $EnemyField.get_child(i))
