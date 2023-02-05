extends KinematicBody2D
class_name BaseLiveObjects

var colision_info

func move(velocity):
	colision_info = move_and_collide(velocity)
	if colision_info:
		velocity = velocity.bounce(colision_info.normal)
	return velocity

func get_class():
	return "BaseLiveObjects"
