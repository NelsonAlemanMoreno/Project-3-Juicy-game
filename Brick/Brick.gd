extends StaticBody2D

var score = 0
var new_position = Vector2.ZERO
var dying = false
export var time_appear = 0.5
export var time_fall = 0.8
export var time_rotate = 1.0
export var time_a = 0.8
export var time_s = 1.2
export var time_v = 1.5

export var sway_amplitude = 3.0
var sway_initial_position = Vector2.ZERO
var sway_randomizer = Vector2.ZERO
var powerup_prob = 0.1

var color_index = 0
var color_distance = 0
var color_completed = true

var colors = [ 
	Color8(224,49,49)
	,Color8(255,146,43)
	,Color8(255,212,59)
	,Color8(148,216,45)
	,Color8(34,139,230)
	,Color8(132,94,247)
	,Color8(190,75,219)
	,Color8(134,142,150)
	]


func _ready():
	randomize()
	position.x = new_position.x
	position.y = -100
	$Tween.interpolate_property(self, "position", position, new_position, time_appear + randf()*2, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	$Tween.start()
	if score >= 100: color_index = 0
	elif score >= 90: color_index = 1
	elif score >= 80: color_index = 2
	elif score >= 70: color_index = 3 
	elif score >= 60: color_index=  4
	elif score >= 50: color_index = 5
	elif score >= 40: color_index = 6
	else: color_index = 7
	$ColorRect.color = colors[color_index]
	sway_initial_position = $ColorRect.rect_position
	sway_randomizer = Vector2(randf()*6-3.0, randf()*6-3.0)

func _physics_process(_delta):
	if dying:
		queue_free()
	elif not $Tween.is_active() and not get_tree().paused:
		color_distance = Global.color_position.distance_to(global_position) / 100
		if Global.color_rotate >= 0:
			$ColorRect.color = colors[int(floor(color_distance + Global.color_rotate)) % len(colors)]
			color_completed = false
		elif not color_completed:
			$ColorRect.color = colors[color_index]
			color_completed = true
	var pos_x = (sin(Global.sway_index)*(sway_amplitude + sway_randomizer.x))
	var pos_y = (cos(Global.sway_index)*(sway_amplitude + sway_randomizer.y))
	$ColorRect.rect_position = Vector2(sway_initial_position.x + pos_x, sway_initial_position.y + pos_y)

func hit(_ball):
	var Brick_sound = get_node_or_null('/root/Game/Brick')
	if Brick_sound != null:
		Brick_sound.play()
	Global.color_rotate = Global.color_rotate_amount
	Global.color_position = _ball.global_position
	die()

func die():
	dying = true
	collision_layer = 0
	Global.update_score(score)
	if not Global.feverish:
		Global.update_fever(score)
	$Tween.interpolate_property(self, "position", position, Vector2(position.x, 1000), time_fall, Tween.TRANS_EXPO, Tween.EASE_IN)
	$Tween.interpolate_property(self, "rotation", rotation, -PI + randf()*2*PI, time_rotate, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($ColorRect, "color:a", $ColorRect.color.a, 0, time_a, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($ColorRect, "color:s", $ColorRect.color.s, 0, time_s, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($ColorRect, "color:v", $ColorRect.color.v, 0, time_v, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

	get_parent().check_level()
	if randf() < powerup_prob:
		var Powerup_Container = get_node_or_null("/root/Game/Powerup_Container")
		if Powerup_Container != null:
			var Powerup = load("res://Powerups/Powerup.tscn")
			var powerup = Powerup.instance()
			powerup.position = position
			Powerup_Container.call_deferred("add_child", powerup)
