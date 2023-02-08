extends Control


signal enhancer_option_item_selected(index)

func _on_exit_button_pressed():
	visible = false


func _on_enhancer_option_item_selected(index):
	emit_signal("enhancer_option_item_selected", index)
