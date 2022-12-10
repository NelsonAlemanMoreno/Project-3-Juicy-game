extends Node2D

func start_fever():
	fever()
	$Timer.start()

func end_fever():
	pass

func _on_Timer_timeout():
	if Global.feverish:
		fever()
		$Timer.start()
	else:
		end_fever()

func fever():
	var ball_container = get_node_or_null("/root/Game/Ball_Container")
	if ball_container != null:
		ball_container.make_ball_fever()
