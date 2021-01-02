extends Label

var mouse_entered = false
signal minionSelected

func _ready():
	print('here')
	self.add_to_group("SelectMinion")
	connect("mouse_entered",self,"_on_SelectMinion_mouse_entered()")
	connect("mouse_exited",self,"_on_SelectMinion_mouse_exited()")
	connect("minionSelected",self.get_parent(),"_on_selectMinion_minionSelected")
	pass # Replace with function body.

func _process(delta):
	var area = get_rect()
	var cursorPosition = get_global_mouse_position()
	if area.has_point(cursorPosition):
		if Input.is_action_just_pressed("leftclick"):
			print(get_text())
			emit_signal("minionSelected",get_text())

func _on_SelectMinion_mouse_entered():
	mouse_entered = true
	print(mouse_entered ," = mouse entered")


func _on_SelectMinion_mouse_exited():
	mouse_entered = false
