extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var spawning = 0
var countdown = 2.0
var continu_spawning = true
# Called when the node enters the scene tree for the first time.
func _ready():
	Fmod.play_one_shot_attached("snapshot:/Default", self)
	Fmod.play_one_shot_attached("event:/Music/Main musique", self)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func bounce(area, direction):
	area.velocity = area.velocity.reflect(direction * area.velocity)

func _on_BordHaut_area_entered(area):
	if area.get_parent().type == "enemi":
		print("enemi bounce")
	var direction = Vector2.DOWN
	bounce(area, direction)
	pass # Replace with function body.

func _on_BordBas_area_entered(area):
	if area.get_parent().type == "enemi":
		print("enemi bounce")
	var direction = Vector2.UP
	bounce(area, direction)
	pass # Replace with function body.


func _on_BordGauche_area_entered(area):
	if area.get_parent().type == "enemi":
		print("enemi bounce")
	else:
		print("")
	var direction = Vector2.RIGHT
	bounce(area, direction)
	pass # Replace with function body.


func _on_BordDroite_area_entered(area):
	if area.get_parent().type == "enemi":
		print("enemi bounce")
	var direction = Vector2.LEFT
	bounce(area, direction)
	pass # Replace with function body.

func _physics_process(delta):
	if continu_spawning:
		countdown -= delta
		if countdown <= 0 and spawning == 0:
			$YSort/Spawner.spawner(GameState.Enemy1, Vector2(689, 436), 0.7)
			countdown = 2.0
			spawning += 1
		if countdown <= 0 and spawning == 1:
			$YSort/Spawner.spawner(GameState.Enemy2, Vector2(885, 207), 0.7)
			countdown = 13.0
			spawning += 1
		if countdown <= 0 and spawning == 2:
			$YSort/Spawner.spawner(GameState.Enemy1, Vector2(660, 207), 0.7)
			countdown = 5.0
			spawning += 1
