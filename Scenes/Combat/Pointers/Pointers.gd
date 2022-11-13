extends Node

@onready var pointers = [$Pointer1, $Pointer2, $Pointer3]
@onready var pos_array = [
	$Pointer1.position,
	$Pointer2.position,
	$Pointer3.position]
@onready var big_pointer_pos = $BigPointer.position

func reset_small_pointers():
	for i in range(3):
		pointers[i].position = pos_array[i]
		pointers[i].visible = false

func reset_big_pointer():
	$BigPointer.position = big_pointer_pos
