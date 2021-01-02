extends Node2D

onready var sprite = $Sprite
onready var overworld = get_parent().get_parent()
onready var tween = $Tween

export var down_frame = 0
export var up_frame = 8
export var horiz_frame = 4


var directions = {"south":Vector2(0,1),"north":Vector2(0,-1),"east":Vector2(1,0),
			"west":Vector2(-1,0)}
var tileSize = 16
var minionType = "lumberjack"
var heldTool = ""
var myname = ""
#declaring commands
var commandListMove = ["move","walk","run","go"]
var commandDirections = [["north","n","u",'up'],["east","right","e","r"],
				["south","down","s","d"],["west","left","w","l"]]
var commandListGrab = ["grab","pick up","pickup","take"]
var commandListInv = ["inv","inventory","held"]
var commandListGetName = ["getname","myname","who"]
var commandListAll = [commandListMove,commandListGrab,commandListInv,commandListGetName]

var commandRunning = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var directionFaced = "south"

export var speed = 2
# Called when the node enters the scene tree for the first time.

signal commandFinished
signal movementFinished
signal interactFinished


func _ready():
	$AnimationPlayer.playback_speed = speed
	update_direction(Vector2(0,1))
	pass # Replace with function body.

func _process(delta):
	
	pass
func _on_ScriptBox_ScriptRunning(allTheLines):
	print(allTheLines)
	for i in range(len(allTheLines)):
		print("\n\nstart of commandline ", i)
		commandRunning = true
		var temp = allTheLines[i]
		var commands = temp.split(' ')
		var commandFinished = self._commands(commands)
		if commandFinished:
			print("commandline ", i ," completed.")
		else:
			commandFinished = self._specialCommands(commands)
			if commandFinished == true:
				print("commandLine ", i," completed.")
			else:
				print("commandLine ",i," is an error.")
		if commandRunning:
			yield(self,"commandFinished")
		yield(get_tree().create_timer(0.5), "timeout")

func _commands(commands): #ex commands = "walk n 1" "interact s" "woodcut s" etc.
	var commandFinished = false
	for i in range(len(commandListAll)):

		if commands[0] in commandListAll[i]:
			
			var command = commandListAll[i][0]
			
			#for command movements
			if command == "move":
				print("MOVE\n-----------------------")
				var dir = self.findDir(commands[1])
				for ii in range(int(commands[2])):
					var moving = move(dir)
					if moving:
						yield(self,"movementFinished")
				commandFinished = true
			elif command == "grab":
				print("GRAB\n-----------------------")
				var dir = self.findDir(commands[1])
				var interacting = interact(command,dir,self,minionType)
				if interacting:
					commandFinished = true
			elif command == "inv":
				print("Minion is now holding ", heldTool)
				commandFinished = true
			elif command == "getname":
				print(getName())
				commandFinished = true
				
	if commandFinished == true:
		commandRunning = false
		emit_signal("commandFinished")
		return true
	else:
		return false
		
		
func _specialCommands(commands):
	emit_signal("commandFinished")
	commandRunning = false
	pass
	
func interact(interaction,dir,requester,minionType):

	update_direction(dir)
	if overworld.requestInteraction(interaction,dir,requester,minionType) == true:
		if interaction == "grab":
			heldTool = overworld.whatWasGrabbed()
		print("Minion is now holding ",heldTool)
	else:
		print("Tried to grab, but could not grab.")
	return true

func update_direction(direction):
	direction = direction / tileSize
	if direction.x == 1:
		sprite.flip_h = false
		sprite.frame = horiz_frame
		directionFaced = "east"
	elif direction.x == -1:
		sprite.flip_h = true
		sprite.frame = horiz_frame
		directionFaced = "west"
	elif direction.y == 1:
		sprite.flip_h = false
		sprite.frame = down_frame
		directionFaced = "south"
	elif direction.y == -1:
		sprite.flip_h = false
		sprite.frame = up_frame
		directionFaced = "north"
func findDir(temp):
	for i in range(len(commandDirections)):
		if temp in commandDirections[i]:
			return ((directions.get(commandDirections[i][0])) * tileSize)
func move(dir):
	update_direction(dir)
	
	var maybe = overworld.requestMove(dir,self) 
	if maybe == true:
		move_tween(dir)
		$AnimationPlayer.play(directionFaced)
		return true
	else:
		$AnimationPlayer.play("bump")
		yield($AnimationPlayer,"animation_finished")
		return false
func move_tween(dir):
	tween.interpolate_property(self, "position",
		position, position + dir,
		1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()
func _on_Tween_tween_completed(object, key):
	if $AnimationPlayer.is_playing():
		yield($AnimationPlayer,"animation_finished")
		print("before emit_signal")
		emit_signal("movementFinished")
	else:
		emit_signal("movementFinished")

func setName(newName):
	myname = newName
	set_name(newName)
func getName():
	return myname


	
	
