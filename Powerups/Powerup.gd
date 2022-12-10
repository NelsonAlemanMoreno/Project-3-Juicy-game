extends Area2D

var payload = null

var payloads = [
	load("res://Powerups/Payload_Grow.tscn")
	,load("res://Powerups/Payload_GrowBall.tscn")
	,load("res://Powerups/Payload_SlowBall.tscn")
	,load("res://Powerups/Payload_AddBall.tscn")
]

var grav_force = 1.0
var velocity = Vector2.ZERO

func _ready():
	randomize()
	payload = payloads[wrapi(randi(), 0, len(payloads))]

func _physics_process(_delta):
	position += velocity
	velocity.y += grav_force
	if position.y > Global.VP.y + 100:
		queue_free()

func _on_Powerup_body_entered(body):
	if body.name == "Paddle":
		if payload != null:
			body.powerup(payload.instance())
