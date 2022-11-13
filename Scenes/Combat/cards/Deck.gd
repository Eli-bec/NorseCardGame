extends Node

var attackCard:PackedScene = load("res://Cards/Sword.tscn")
var defendCard:PackedScene = load("res://Cards/Shield.tscn")
var maneuverCard:PackedScene = load("res://Cards/Grab.tscn")

var ratio:Array :
	set(value):
		var sum:float = value[0] + value[1] + value[2]
		ratio = [value[0]/sum, value[1]/sum, value[2]/sum]

var rng = RandomNumberGenerator.new()

func pop_random_card() -> PackedScene:
	var num = rng.randf()
	if num <= ratio[0]: return attackCard
	elif num <= ratio[0] + ratio[1] or ratio[2] == 0: return defendCard
	return maneuverCard
