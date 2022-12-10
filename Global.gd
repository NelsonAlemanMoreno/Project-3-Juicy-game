extends Node

var VP = Vector2.ZERO
var level = 0
var score = 0
var lives = 0
var time = 0
var fever = 0
var fever_multiplier = 0.15
var starting_in = 0

var fever_decay = 0.1
var feverish = false


export var default_starting_in = 4
export var default_lives = 5

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	randomize()
	VP = get_viewport().size
	var _signal = get_tree().get_root().connect("size_changed",self,"_resize")
	reset()

func _physics_process(_delta):
	if fever >= 100 and not feverish:
		fever = 100
	elif fever > 0:
		update_fever(-fever_decay)
	else:
		feverish = false
		

func _input(event):
	if event.is_action_pressed("menu"):
		var Pause_Menu = get_node_or_null("/root/Game/UI/Pause_Menu")
		if Pause_Menu == null or starting_in > 0:
			get_tree().quit()
		else:
			if Pause_Menu.visible:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
				get_tree().paused = false
				Pause_Menu.hide()
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				get_tree().paused = true
				Pause_Menu.show()
	if fever >= 100 and event.is_action_pressed("fever"):
		var Fever = get_node_or_null("/root/Game/Fever")
		if Fever != null:
			feverish = true
			Fever.start_fever()

func _resize():
	VP = get_viewport().size

func reset():
	level = 0
	score = 0
	lives = default_lives
	starting_in = default_starting_in

func update_score(s):
	score += s
	var HUD = get_node_or_null("/root/Game/UI/HUD")
	if HUD != null:
		HUD.update_score()

func update_lives(l):
	lives += l
	var HUD = get_node_or_null("/root/Game/UI/HUD")
	if HUD != null:
		HUD.update_lives()
	if lives <= 0:
		end_game(false)

func update_fever(f):
	fever += f * fever_multiplier
	var HUD = get_node_or_null("/root/Game/UI/HUD")
	if HUD != null:
		HUD.update_fever()

func update_time(t):
	time += t
	var HUD = get_node_or_null("/root/Game/UI/HUD")
	if HUD != null:
		HUD.update_time()
	if time <= 0:
		next_level()

func next_level():
	level += 1
	fever = 0
	var _scene = get_tree().change_scene("res://Game.tscn")

func end_game(success):
	if success:
		var _scene = get_tree().change_scene("res://UI/End_Game.tscn")
	else:
		var _scene = get_tree().change_scene("res://UI/End_Game.tscn")
