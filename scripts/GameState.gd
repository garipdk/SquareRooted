extends Node2D

onready var player = get_node("/root/Level1/YSort/Player")

onready var bordHautCS2D   = get_node("/root/Level1/YSort/BordHaut/CollisionShape2D")
onready var bordBasCS2D    = get_node("/root/Level1/YSort/BordBas/CollisionShape2D")
onready var bordDroitCS2D  = get_node("/root/Level1/YSort/BordDroite/CollisionShape2D")
onready var bordGaucheCS2D = get_node("/root/Level1/YSort/BordGauche/CollisionShape2D")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var _unused_warning
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
