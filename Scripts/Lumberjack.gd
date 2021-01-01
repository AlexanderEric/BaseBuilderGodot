extends "res://Scripts/Minion.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var held_Tool = {"axe" : false,"seed" : false,"shovel" : false}
var woodcuttingList = ["cut","chop","wc"]
var plantingList = ["plant"]
var clearingList = ["clear","dig"]
var specialCommandsList = [woodcuttingList,plantingList,clearingList]
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _specialCommands(commands):
	print(commands[0])
	for i in range(len(specialCommandsList)):
		if commands[0] in specialCommandsList[i]:
			var command = specialCommandsList[i][0]
			if command == "cut":
				print("Lumberjack Cut!")
				var dir = .findDir(commands[1])
				.interact(command,dir)
			if command == "plant":
				var dir = .findDir(commands[1])
			if command == "clear":
				pass
	emit_signal("commandFinished")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


