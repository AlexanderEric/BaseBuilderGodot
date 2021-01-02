extends TextEdit

var PlayIcon = load("res://Assets/ScriptBox/Play.png")
var StopIcon = load("res://Assets/ScriptBox/Stop.png")
var SaveIcon = load("res://Assets/ScriptBox/Save.png")
var LoadIcon = load("res://Assets/ScriptBox/Load.png")
onready var Run = $Run
onready var Save = $Save
onready var Load = $Load
onready var LoadName = $LoadName
onready var Savename = $SaveName
var TextureToggle = 1

signal ScriptRunning
signal ScriptStop

# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().add_to_group("ScriptBoxActive")
	var minionSelected = get_parent().get_parent()
	$Run.connect("pressed",self,"_on_Run_pressed")
	$Save.connect("pressed",self,"_on_Save_pressed")
	$Load.connect("pressed",self,"_on_Load_pressed")
	$LoadName.connect("text_entered",self,"_on_LoadName_text_entered")
	$SaveName.connect("text_entered",self,"_on_SaveName_pressed")
	connect("ScriptRunning",minionSelected,"_on_ScriptBox_ScriptRunning")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Run_pressed():
	if TextureToggle == 1:
		$Run.texture_pressed = StopIcon
		$Run.texture_normal = StopIcon
		TextureToggle = 2
		var allTheLines = []
		for i in range(self.get_line_count()):
			allTheLines.append(self.get_line(i))
		emit_signal("ScriptRunning",allTheLines)
	else:
		$Run.texture_pressed = PlayIcon
		$Run.texture_normal = PlayIcon
		TextureToggle = 1
		emit_signal("ScriptStop")
func _on_Save_pressed():
	print("Enter a Save Name and press enter")
	$SaveName.show()
	$SaveName.set_editable(true)


func _on_Load_pressed():
	print(list_files_in_directory("user://"))
	print("Enter a Save Name and press Enter")
	$LoadName.set_editable(true)
	$LoadName.show()


func _on_SaveName_text_entered(new_text):
	if $SaveName.is_visible() == true:
		var file = File.new()
		
		file.open("user://"+new_text+".txt", File.WRITE)
		file.store_string(self.get_text())
		print(self.get_text())
		file.close()
		print("Game saved as "+new_text+".txt")
		$SaveName.hide()
		$SaveName.set_text("")
		$SaveName.set_editable(false)


func _on_LoadName_text_entered(new_text):
	var file = File.new()
	
	if new_text +".txt" in list_files_in_directory("user://"):
		file.open("user://"+new_text+".txt", File.READ)
		var allthelines = []
	
		while !file.eof_reached():
			var line = file.get_line()
			allthelines.append(line)
	
		file.close()
		print("saving\n",allthelines)
		self.set_text("\n")
	
		for i in range(len(allthelines)):
			var newLine = allthelines[i]+"\n"
			self.set_line(i,newLine)
			print(allthelines[i])
		file.close()
		print("Game loaded as "+new_text+".txt")
		$LoadName.hide()
		$LoadName.set_text("")
		$SaveName.set_editable(false)
	else:
		print("Error! Try again")
		$LoadName.hide()
		$LoadName.set_text("")
		$SaveName.set_editable(false)
		
func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)

	dir.list_dir_end()

	return files


func _on_Stop_pressed():
	pass # Replace with function body.


