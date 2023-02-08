class_name BubbleDialogueSequence
extends Control

signal sequence_end

var active:bool = false

var _sequence:Array[Array]
var sequenceId:String
var next:int

var paused_tweens = []

# show the dialogue sequence passed in
# the sequence should be in the format
# [character_name:String, [dialogues...]]
func show_sequence(squence_id:String = ""):
	sequenceId = sequenceId
	next = 0
	next_dialogue()
	visible = true
	active = true
	Global.suppress_input = true
	for tween in get_tree().get_processed_tweens():
		if tween.is_running():
			tween.pause()
			paused_tweens.append(tween)

func next_dialogue():
	if next >= len(_sequence):
		print("sequence ended")
		on_end_of_sequence()
		return
	var dialogue = _sequence[next]
	dialogue[0].get_child(0).text = dialogue[1]
	next += 1

func _input(event):
	if active and event is InputEventMouseButton:
		if event.is_pressed():
			get_viewport().set_input_as_handled()
			next_dialogue()

func on_end_of_sequence():
	visible = false
	active = false
	Global.suppress_input = false
	for tween in paused_tweens:
		tween.play()
	emit_signal('sequence_end')
	queue_free()
