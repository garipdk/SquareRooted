extends BaseLiveObjects
class_name Enemies

var type = "enemi"

var is_hited = false
onready var spawner = get_parent()
func get_class_name():
	return "Enemies"

