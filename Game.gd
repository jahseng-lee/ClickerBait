extends MarginContainer

const Upgrade = preload("res://Upgrade.gd")

var totalMoney = 0
var totalLinesOfCode = 0
var totalDevelopers = 0
var totalDevOps = 0

var dollarPerSecond = 1 + (0.1 * totalDevelopers)
var linesOfCodePerSecond = 0.1 + (1 * totalDevelopers * totalDevOps)

var upgradesRemaining = []
var upgradesShowing = [] # the next 3 upgrades in a list 

func _ready():
	_loadUpgradesRemaining()
	

func _loadUpgradesRemaining():
	var file = File.new()
	file.open("res://Upgrades.json", file.READ)
	
	var text = file.get_as_text()
	var upgradesJson = parse_json(text)
	
	file.close()
	
	for key in upgradesJson.keys():
		var new_upgrade = Upgrade.new()
		new_upgrade.init(key, upgradesJson[key])
		
		upgradesRemaining.append(new_upgrade)

func _process(delta):
	_loadUpgradesShowing()
	_applyUpgrades() # TODO
	
	_updateLinesOfCode(delta)
	_updateMoney(delta)

func _loadUpgradesShowing():
	if upgradesShowing.size() < 3:
		var i = 0
		
		while upgradesShowing.size() < 3:
			upgradesShowing.append(upgradesRemaining[i])
			i += 1
		
		for upgrade in upgradesShowing:
			var new_upgrade = $HUD/Upgrade.duplicate()
			var new_upgrade_link = new_upgrade.get_node("UpgradeLink")
			
			new_upgrade.get_node("UpgradeDivider").visible = true
			
			new_upgrade_link.set_disabled(false)
			new_upgrade_link.text = upgrade.title()
			
			var new_upgrade_costs = new_upgrade.get_node("UpgradeCosts")
			new_upgrade_costs.get_node("UpgradeCostsLabel").visible = true
			new_upgrade_costs.get_node("UpgradeCostsValue").text = "    - %s" % upgrade.costs()
			
			var new_upgrade_requirements = new_upgrade.get_node("UpgradeRequirements")
			new_upgrade_requirements.get_node("UpgradeRequirementsLabel").visible = true
			new_upgrade_requirements.get_node("UpgradeRequirementsValue").text = "    - %s" % upgrade.requirements()
			
			$HUD/Upgrades.add_child(new_upgrade)

func _applyUpgrades():
	pass

func _updateLinesOfCode(delta):
	totalLinesOfCode = totalLinesOfCode + (linesOfCodePerSecond * delta)
	
	var linesOfCode = str(int(totalLinesOfCode))
	$HUD/CompanyStats/LinesOfCode/LinesOfCodeValue.text = linesOfCode

func _updateMoney(delta):
	totalMoney = totalMoney + (dollarPerSecond * delta)
	
	var money_value = "%*.*f" % [0, 2, totalMoney]
	$HUD/CompanyStats/MoneyContainer/MoneyValue.text = "$" + money_value