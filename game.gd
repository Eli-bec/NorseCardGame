extends Node

signal start_combat

########## Virtual methods ##########
func _ready():
	$dialogueManager.show_sequence([
		['', '* opening dialogues *'],
		['Loki', "I will teach you how to fight."]])
	$dialogueManager.sequence_end.connect(emit_signal.bind('start_combat'))
#	$bubbleDialogueManager.show_sequence()
#	$bubbleDialogueManager.sequence_end.connect(emit_signal.bind('start_combat'))
	
	$playerDisplay.init("Player", 10, 10)
	$enemyDisplay.init("Loki", 14, 14)
#	emit_signal.call_deferred('start_combat')


########## Signal callbacks ##########
func _on_start_combat():
	$Combat/player.hp_change.connect($playerDisplay.set_hp)
	$Combat/enemy.hp_change.connect($enemyDisplay.set_hp)
