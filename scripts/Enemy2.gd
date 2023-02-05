extends Enemies

var knockback = Vector2.ZERO
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var hitbox = $Hitbox

export (int) var max_speed = 6
export (int) var max_speed_knockback = 12
export (int) var acceleration = 13
export (int) var friction = 40
export (int) var friction_knockback = 4
export (float) var cooldown_base = 4.0

var cooldown = cooldown_base
var velocity
var movement = false

var input_vector
var max_speed_use = max_speed
func _ready():
	randomize()
	velocity = Vector2(rand_range(-1.0, 1.0), rand_range(-1.0, 1.0))
	randomize()
	input_vector = Vector2(rand_range(-1.0, 1.0), rand_range(-1.0, 1.0))
	animationTree.active = true
	hitbox.knockback_vector = velocity

func _physics_process(delta):
	if colision_info:
		randomize()
		input_vector = Vector2(rand_range(-1.0, 1.0), rand_range(-1.0, 1.0))
		cooldown = cooldown_base
	if cooldown <= 0:
		randomize()
		input_vector = Vector2(rand_range(-1.0, 1.0), rand_range(-1.0, 1.0))
		cooldown = cooldown_base
	else:
		cooldown -= delta
		
	knockback = knockback.move_toward(Vector2.ZERO, friction_knockback * delta)
	if knockback != Vector2.ZERO:
		animationTree.set("parameters/Run_en1/blend_position", knockback)
		animationTree.set("parameters/Idle_en1/blend_position", knockback)
		knockback = move(knockback)
	elif movement:
			hitbox.knockback_vector = velocity
			input_vector = input_vector.normalized()
			
			if input_vector != Vector2.ZERO:
				animationTree.set("parameters/Idle_en1/blend_position", input_vector)
				animationTree.set("parameters/Run_en1/blend_position", input_vector)
				velocity = velocity.move_toward(input_vector * max_speed_use, acceleration * delta)
				velocity = velocity.move_toward(Vector2.ZERO, friction * delta * (abs(velocity.angle_to(input_vector)) / PI) )
			else :
				velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			if velocity != Vector2.ZERO:
				animationState.travel("Run_en1")
			else:
				animationState.travel("Idle_en1")
			
			velocity = move(velocity)
	else:
		animationTree.set("parameters/Run_en1/blend_position", velocity)
		animationState.travel("Run_en1")
		#velocity = move_and_slide(Vector2.ZERO)
	
	if knockback != Vector2.ZERO:
		is_hited = true
	else:
		is_hited = false

func _on_Hurtbox_area_entered(area):
	GameState._unused_warning = move(Vector2.ZERO)
	knockback = area.knockback_vector * max_speed_knockback


func get_node_type():
	return GameState.Enemy2


func activate_movement():
	movement = true

func deactivate_movement():
	movement = false


func _on_Hitbox_Fusion_area_entered(area):
	if spawner.fusion_area_entered(self, area):
		get_parent().remove_child(area.get_parent())
		area.queue_free()
		queue_free()
