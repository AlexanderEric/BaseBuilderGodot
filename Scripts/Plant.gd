extends "res://Scripts/Interactable.gd"

signal toolGrabbed
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func doesThis(interaction,direction,requester,minionType):
	print('ok')
	if interaction == "grab":
		var returnList = [true,"plant"]
		return returnList
	else:
		var returnList = ["false"]
		return returnList
	
