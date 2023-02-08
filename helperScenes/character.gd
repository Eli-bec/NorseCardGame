class_name Character
extends Node

signal hp_change

var effects = {}

var hp:int :
	set(value):
		hp = value
		print('hp_change')
		emit_signal('hp_change', hp)

func discard(card:Card):
	$Deck.discard(card)

func damage(amount:int):
	if 'shapeshift' in effects:
		for i in range(len(effects['shapeshift'])):
			if effects['shapeshift'][i] > 0:
				return
				
	if 'dodge' in effects:
		for i in range(len(effects['dodge'])):
			if effects['dodge'][i] > 0:
				effects['dodge'][i] -= 1
				return
				
	if 'block' in effects:
		for i in range(len(effects['block'])):
			amount -= effects['block'][i]
			if amount <= 0:
				effects['block'][i] = -amount
				return
			effects['block'][i] = 0
	hp -= amount
	emit_signal("hp_change", hp)

func add_effect(name:String, value:Array):
	if name not in effects:
		effects[name] = value
		return
	while len(effects[name]) < len(value):
		effects[name].append(0)
	for i in range(len(value)):
		effects[name][i] += value[i]

func _on_combat_new_turn():
	if 'dodge' in effects:
		effects['dodge'].pop_front()
	if 'shapeshift' in effects:
		effects['shapeshift'].pop_front()
	if 'block' in effects:
		effects['block'].pop_front()
	for name in effects:
		if len(effects[name]) == 0:
			effects.erase(name)
