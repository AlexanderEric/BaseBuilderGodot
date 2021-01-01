extends Node2D
onready var minion = $Minion
onready var interactiveTiles = $InteractiveTiles
var stale_children = false
var wasGrabbed = ""
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	refresh_children()

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func requestMove(direction,requester):
	var cell_start = interactiveTiles.world_to_map(requester.position)
	var cell_target = interactiveTiles.world_to_map(requester.position + direction)
	
	var cell_target_type = interactiveTiles.get_cellv(cell_target)
	if cell_target_type == -1:
		return true
	else:
		return false

func requestInteraction(interaction,direction,requester,minionType):
	var target = interactiveTiles.world_to_map(requester.position + direction)
	var children = interactiveTiles.get_children()

	for i in range(len(children)):

		if target == interactiveTiles.world_to_map(children[i].position):
			var interactable = get_overworld_obj(target)
			var returnList = interactable.doesThis(interaction,direction,requester,minionType)
			
			if interaction == "grab" and returnList[0] == true:
				wasGrabbed = returnList[1]
				return returnList[0]
			else:
				return returnList[0]

func whatWasGrabbed():
	return wasGrabbed

func _on_Spade_toolGrabbed():
	pass # Replace with function body.
	
func get_overworld_obj(coordinates):
	var children = interactiveTiles.get_children()
	for node in children:
		# Protects against certain situations where an object is queued to be
		# freed
		if !is_instance_valid(node):
			stale_children = true
			continue
		else:
			if interactiveTiles.world_to_map(node.position) == coordinates:
				return(node)
	if stale_children:
		stale_children = false
		refresh_children()
func refresh_children():
	var children = interactiveTiles.get_children()
	children = interactiveTiles.get_children()
