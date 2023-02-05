extends Node2D
var new_num
var pos
var cooldown = 1.0
var spawning = false
onready var missile = preload("res://scenes/Projectile.tscn")

func spawner(num, pos0, sc):
	var spawning0 = GameState.scenes[num].instance()
	spawning0.position = pos0
	spawning0.scale = Vector2(sc, sc)
	add_child(spawning0)

func spawner_missil(p, v, s):
	var spawning0 = missile.instance()
	spawning0.init(p,v,s)
	add_child(spawning0)
func fusion_area_entered(itself, area_in):
	var area = area_in.get_parent()
	if area.is_hited:
		if area.get_class() == itself.get_class():
			new_num = area.get_node_type() + itself.get_node_type()
			if new_num < 5:
				pos = (area.position + itself.position)/2
				spawning = true
				return true
	return false

func _physics_process(delta):
	if spawning:
		cooldown -= delta
		if cooldown <= 0:
			cooldown = 1.0
			spawning = false
			print(pos)
			spawner(new_num, pos, 0.7)
