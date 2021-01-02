extends Node2D
onready var minion = $Minion
onready var interactiveTiles = $InteractiveTiles
onready var minionBasic = "res://Scenes/Minion.tscn"
onready var cameraScriptBox = "res://Scenes/CameraScriptBox.tscn"
onready var selectMinion = "res://Scenes/SelectMinion.tscn"
var stale_children = false
var wasGrabbed = ""
var selectMinionActive = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	refresh_children()
	instantiate_player(2)
	var camera = Camera2D.new()
	self.add_child((camera))
	camera.set_zoom(Vector2(0.2,0.2))
	camera.make_current()
	pass # Replace with function body.

	
func _process(delta):
	var cursorTarget = interactiveTiles.world_to_map(get_global_mouse_position())
	var minions = $Minions.get_children()
	var minionsList = []
	for i in range(len(minions)):
		var currentMinion = minions[i]
		var minionPosition = interactiveTiles.world_to_map(currentMinion.position)
		var minionName = currentMinion.get_name()
		
		minionsList.append([minionPosition,minionName,currentMinion])
	
	var minionsSelected = []
	for i in range(len(minionsList)):
		if minionsList[i].has(cursorTarget):
			minionsSelected.append(minionsList[i])
	var minionCount = len(minionsSelected)	
	if Input.is_action_just_pressed("leftclick") and selectMinionActive == false:
		
		if (minionCount) == 1:
			#print("There is one minion here, their name is ", minionsSelected[0][1])
			selectMinion(minionsSelected)
		elif minionCount == 0:
			print("No minions here!")
		else:
			var namesList = []
			for i in range(minionCount):
				namesList.append(minionsSelected[i][1])
			#print("There is many minions here, their names are ", namesList)
			selectMinion(minionsSelected)
			
func selectMinion(minionsSelected):
	var minionPosition = minionsSelected[0][0]
	var cursorPosition = get_global_mouse_position()
	if len(minionsSelected) == 1:
		clearScriptBox()
		var minionNode = get_node("Minions/"+minionsSelected[0][1])
		var cameraScriptBoxLoaded = load(cameraScriptBox).instance()
		minionNode.add_child(cameraScriptBoxLoaded)
		cameraScriptBoxLoaded.make_current()
	else:
		selectMinionActive = true
		var labelList = []
		for i in range(len(minionsSelected)):
			var currentLabel = load(selectMinion).instance()
			self.add_child(currentLabel)
			currentLabel.set_scale(Vector2(0.5,0.5))
			currentLabel.set_position( cursorPosition + Vector2(-5 ,5 + i*8))
			currentLabel.set_text(minionsSelected[i][1])

func _on_selectMinion_minionSelected(minionSelected):
	clearScriptBox()
	var children = self.get_children()
	for label in get_tree().get_nodes_in_group("SelectMinion"):
		label.queue_free()
	var minions = $Minions.get_children()
	var minionsList = []
	print(minionSelected)
	for i in range(len(minions)):
		var currentMinion = minions[i]
		var minionPosition = interactiveTiles.world_to_map(currentMinion.position)
		var minionName = currentMinion.get_name()
		
		minionsList.append([minionPosition,minionName,currentMinion])
	for minion in minionsList:
		print(minion[1])
		if minion[1] == minionSelected:
			var currentMinion = minion[2]
			var minionNode = get_node("Minions/"+minion[1])
			var cameraScriptBoxLoaded = load(cameraScriptBox).instance()
			minionNode.add_child(cameraScriptBoxLoaded)
			cameraScriptBoxLoaded.make_current()
	selectMinionActive = false
	pass


func clearScriptBox():
	for scriptBox in get_tree().get_nodes_in_group("ScriptBoxActive"):
		scriptBox.queue_free()
func instantiate_player(amount):
	
	var spawn_points = $BackgroundTiles.get_children()
	
	# If we somehow don't have that spawn point, fall back to 0
	

	# Spawn the player and add to scene
	for i in range(amount):
		print("spawning minion ",i)
		var player_spawn = load(minionBasic).instance()
		$Minions.add_child(player_spawn)
		
	# Set player at the correct position (spawn point of zone)

		player_spawn.position = spawn_points[i].position
		player_spawn.set_name(str(i))
		player_spawn.setName(str(i))
	# Make the player face the direction from last movement to create a
	# "seamless" feel

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
	var whatWasGrabbed = wasGrabbed
	wasGrabbed = ""
	return whatWasGrabbed
	

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


func _on_SelectMinion_mouse_entered():
	pass # Replace with function body.
