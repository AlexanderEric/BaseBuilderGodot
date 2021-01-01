extends Node2D

onready var sprite = $Sprite
onready var overworld = get_parent()
onready var tween = $Tween

export var down_frame = 0
export var up_frame = 8
export var horiz_frame = 4


var directions = {"south":Vector2(0,1),"north":Vector2(0,-1),"east":Vector2(1,0),
			"west":Vector2(-1,0)}
var tileSize = 16
var minionType = "lumberjack"
var heldTool = ""
#declaring commands
var commandListMove = ["move","walk","run","go"]
var commandDirections = [["north","n","u",'up'],["east","right","e","r"],
				["south","down","s","d"],["west","left","w","l"]]
var commandListGrab = ["grab","pick up","pickup","take"]
var commandListAll = [commandListMove,commandListGrab]


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


func _on_ScriptBox_ScriptRunning(allTheLines):
	print(allTheLines)
	for i in range(len(allTheLines)):
		var temp = allTheLines[i]
		var commands = temp.split(' ')
		self._commands(commands)
		yield(self,"commandFinished")
		
func _commands(commands): #ex commands = "walk n 1" "interact s" "woodcut s" etc.
	var commandFinished = false
	for i in range(len(commandListAll)):

		if commands[0] in commandListAll[i]:
			
			var command = commandListAll[i][0]
			var dir = self.findDir(commands[1])
			#for command movements
			if command == "move":
				for ii in range(int(commands[2])):
					move(dir)
					yield(self,"movementFinished")
				commandFinished = true
			elif command == "grab":
				var temp = interact(command,dir,self,minionType)
				if temp == true:
					commandFinished = true
				
	#print(commandFinished)
	if commandFinished == true:
		print("commandFinished Successfully!")
		emit_signal("commandFinished")
	else:
		self._specialCommands(commands)
		
		
func _specialCommands(commands):
	print("No commands here! Special or basic.")
	emit_signal("commandFinished")
	pass
	
func interact(interaction,dir,requester,minionType):
	update_direction(dir)
	if overworld.requestInteraction(interaction,dir,requester,minionType) == true:
		if interaction == "grab":
			heldTool = overworld.whatWasGrabbed()
		print("Minion is now holding ",heldTool)
	else:
		print("RequestInteraction = false")
	emit_signal("interactFinished")
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
	else:
		$AnimationPlayer.play("bump")
		yield($AnimationPlayer,"animation_finished")
		emit_signal("movementFinished")
func move_tween(dir):
	tween.interpolate_property(self, "position",
		position, position + dir,
		1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()
func _on_Tween_tween_completed(object, key):
	emit_signal("movementFinished")
