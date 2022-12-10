extends Node2D

var type = "add_ball"

func _ready():
	$Timer.start()
	var Ball_Container = get_node_or_null("/root/Game/Ball_Container")
	if Ball_Container != null:
		Ball_Container.make_ball_fever()

func payload():
	pass
	
func _on_Timer_timeout():
	queue_free()
