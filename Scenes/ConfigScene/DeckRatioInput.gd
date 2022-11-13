extends HBoxContainer

signal value_changed(value:Array[float])

var value:Array :
	set (val):
		$AttackPortion.value = val[0]
		$DefendPortion.value = val[1]
		$ManeuverPortion.value = val[2]

func _on_attack_portion_value_changed(value):
	# make sure the sum of the portions is not 0
	if not ($AttackPortion.value or $DefendPortion.value or $ManeuverPortion.value):
		$AttackPortion.value = 1
	# update configuration
	@warning_ignore(return_value_discarded)
	emit_signal('value_changed', [
		$AttackPortion.value,
		$DefendPortion.value,
		$ManeuverPortion.value
	])


func _on_defend_portion_value_changed(value):
	# make sure the sum of the portions is not 0
	if not ($AttackPortion.value or $DefendPortion.value or $ManeuverPortion.value):
		$DefendPortion.value = 1
	# update configuration
	@warning_ignore(return_value_discarded)
	emit_signal('value_changed', [
		$AttackPortion.value,
		$DefendPortion.value,
		$ManeuverPortion.value
	])


func _on_maneuver_portion_value_changed(value):
	# make sure the sum of the portions is not 0
	if not ($AttackPortion.value or $DefendPortion.value or $ManeuverPortion.value):
		$ManeuverPortion.value = 1
	# update configuration
	@warning_ignore(return_value_discarded)
	emit_signal('value_changed', [
		$AttackPortion.value,
		$DefendPortion.value,
		$ManeuverPortion.value
	])
