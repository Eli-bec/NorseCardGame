extends Sprite2D
class_name Character

@export var Name:String = ''
@export var HP:int = 1
@export var max_HP:int = 1

signal defeated

func _ready():
	$"VBoxContainer/Name Label".text = Name
	update_HP()

func update_HP():
	$"VBoxContainer/HP Label".text = "{HP} / {max_HP}".format({"HP": HP, "max_HP": max_HP})

func take_damage(amount:int = 1):
	HP -= 1
	update_HP()
	if HP == 0:
		emit_signal('defeated')
