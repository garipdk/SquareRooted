extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = Vector2.ZERO
var speed = 0.0
var is_hited = false
var type = "projectile"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_and_collide(velocity * speed)

func init(p,v,s):
	global_position = p
	velocity = v.normalized()
	speed = s
	print("Boom ! [%f,%f] + [%f,%f]*(%f)" % [p.x, p.y, v.x, v.y, s])

func _on_Hurtbox_area_entered(area):
	pass
#	print(area.name)
#	if area.name == "player":
#	print("Man down [%f,%f]" % [global_position.x,global_position.y])
#	queue_free()
