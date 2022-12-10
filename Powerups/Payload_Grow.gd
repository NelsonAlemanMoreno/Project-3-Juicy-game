extends Node2D

var type = "grow"

func _ready():
	$Timer.start()
	var paddle = find_parent("Paddle")
	if paddle != null:
		paddle.call_deferred("set_scale", Vector2(2,2))
		paddle.width = paddle.width_default * 2

func payload():
	pass
	
func _on_Timer_timeout():
	var paddle = find_parent("Paddle")
	if paddle != null:
		paddle.call_deferred("set_scale", Vector2(1,1))
		paddle.width = paddle.width_default
	queue_free()
