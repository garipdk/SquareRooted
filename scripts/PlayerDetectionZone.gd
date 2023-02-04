extends Area2D

var player = null


var velocity = Vector2.ZERO

func detect_player():
	return player != null

func _on_PlayerDetectionZone_body_entered(body):
	player = body


func _on_PlayerDetectionZone_body_exited(_body):
	player = null
