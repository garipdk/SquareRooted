extends Control

var PLayer = 0
var Enemy1 = 1
var Enemy2 = 2
var Enemy3 = 3
var Enemy4 = 4

onready var scenes : Dictionary = {
	PLayer     : load("res://scenes/Player.tscn"),
	Enemy1     : load("res://scenes/Enemy1.tscn"),
	Enemy2     : load("res://scenes/Enemy2.tscn"),
	Enemy3     : load("res://scenes/Enemy3.tscn"),
	Enemy4     : load("res://scenes/Enemy4.tscn"),
}


onready var player = get_node("/root/Level1/YSort/Player")

onready var bordHautCS2D   = get_node("/root/Level1/YSort/BordHaut/CollisionShape2D")
onready var bordBasCS2D    = get_node("/root/Level1/YSort/BordBas/CollisionShape2D")
onready var bordDroitCS2D  = get_node("/root/Level1/YSort/BordDroite/CollisionShape2D")
onready var bordGaucheCS2D = get_node("/root/Level1/YSort/BordGauche/CollisionShape2D")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var _unused_warning


func is_perfect_square(x):
	if x * 1.0 == 1.0:
		return false
	var sr = sqrt(x * 1.0)
	return floor(sr) == sr
