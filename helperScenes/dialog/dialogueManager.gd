class_name DialogueManager
extends Control

signal sequence_end

var active:bool = false

var _sequence:Array[Array]
var sequenceId:String
var next:int

@onready var nameLabel = $MarginContainer/VBoxContainer/nameLabel
@onready var label = $MarginContainer/VBoxContainer/Label

# show the dialogue sequence passed in
# the sequence should be in the format
# [character_name:String, [dialogues...]]
func show_sequence(sequence, squence_id:String = ""):
	_sequence = sequence
	sequenceId = sequenceId
	next = 0
	next_dialogue()
	visible = true
	active = true
	Global.suppress_input = true

func next_dialogue():
	if next >= len(_sequence):
		print("sequence ended")
		on_end_of_sequence()
		return
	var dialogue = _sequence[next]
	nameLabel.text = "[%s]" % dialogue[0]
	label.text = dialogue[1]
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
	emit_signal('sequence_end')
