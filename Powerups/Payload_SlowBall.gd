extends Node2D

var type = "slow_ball"

func _ready():
	$Timer.start()
	var Ball_Container = get_node_or_null("/root/Game/Ball_Container")
	if Ball_Container != null:
		for c in Ball_Container.get_children():			
			c.call_deferred("change_speed", 0.5)

func payload():
	pass
	
func _on_Timer_timeout():
	print("timeout")
	var Ball_Container = get_node_or_null("/root/Game/Ball_Container")
	if Ball_Container != null:
		for c in Ball_Container.get_children():
			c.call_deferred("change_speed", 1.0)
	queue_free()
