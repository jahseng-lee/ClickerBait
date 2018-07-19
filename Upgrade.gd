extends Node

var upgradeName
var requirements
var cost
var reward

func _ready():
	pass

func init(name, values):
	upgradeName = name
	
	requirements = values.requirements
	cost = values.cost
	reward = values.reward

func title():
	return upgradeName.replace("_", " ").capitalize()

func costs():
	if cost == null:
		return "None"
	else:
		return str(cost).replace("(", "").replace(")", "").replace(":", ": ")

func requirements():
	if requirements == null:
		return "None"
	else:
		return str(requirements).replace("(", "").replace(")", "").replace(":", ": ")