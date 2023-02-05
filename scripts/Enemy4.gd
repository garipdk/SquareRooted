extends Enemies

var knockback = Vector2.ZERO
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var hitbox = $Hitbox

export (int) var max_speed = 12
export (int) var acceleration = 30
export (int) var max_speed_knockback = 12
export (int) var friction = 40
export (int) var friction_knockback = 4

export (float) var cooldown_attack = 2.2
export (float) var cooldown_hit = 3.0
var cooldown_h = cooldown_hit

var health = 4
var is_attacked = false
var cooldown = cooldown_attack
var velocity = Vector2.ZERO
var movement = false
var start_cooldown = true
onready var player = GameState.player
onready var input_vector = (player.global_position - global_position).normalized()
var max_speed_use = max_speed
func _ready():
	
	animationTree.active = true
	hitbox.knockback_vector = velocity

func _physics_process(delta):
	if is_attacked and cooldown_h <= 0:
		health -= 1
		cooldown_h = cooldown_hit
	else:
		cooldown_h -= delta
	if colision_info or velocity == Vector2.ZERO:
		start_cooldown = true
	if start_cooldown and input_vector != Vector2.ZERO:
		if cooldown <= 0:
			input_vector = (player.global_position - global_position).normalized()
			movement = true
			cooldown = cooldown_attack
			start_cooldown = false
		else:
			movement = false
			cooldown-=delta
	knockback = knockback.move_toward(Vector2.ZERO, friction_knockback * delta)
	if knockback != Vector2.ZERO:
		animationTree.set("parameters/Run_en1/blend_position", knockback)
		animationTree.set("parameters/Idle_en1/blend_position", knockback)
		knockback = move(knockback)
	elif player != null and input_vector != null:
		if movement:
			hitbox.knockback_vector = velocity
			input_vector = input_vector.normalized()
			if input_vector != Vector2.ZERO:
				animationTree.set("parameters/Idle_en1/blend_position", (player.global_position - global_position).normalized())
				animationTree.set("parameters/Run_en1/blend_position", (player.global_position - global_position).normalized())
				velocity = velocity.move_toward(input_vector * max_speed_use, acceleration * delta)
			else :
				velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			if velocity != Vector2.ZERO:
				animationState.travel("Run_en1")
			else:
				animationState.travel("Idle_en1")
			velocity = move(velocity)
		else:
			animationTree.set("parameters/Idle_en1/blend_position", (player.global_position - global_position).normalized())
			animationState.travel("Idle_en1")
	else:
		input_vector = (player.global_position - global_position).normalized()
		player = GameState.player
	
	if knockback != Vector2.ZERO:
		is_hited = true
	else:
		is_hited = false

func _on_Hurtbox_area_entered(area):
	GameState._unused_warning = move_and_slide(Vector2.ZERO)
	knockback = area.knockback_vector * max_speed_knockback
	is_attacked = true


func get_node_type():
	return GameState.Enemy4


func _on_Hurtbox_area_exited(_area):
	is_attacked = false
