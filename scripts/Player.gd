extends BaseLiveObjects
class_name Player
export (int) var max_speed = 10
export (int) var acceleration = 15
export (int) var roll_speed = 12
export (int) var friction = 40
export (float) var max_speed_knockback = 1.2
export (int) var friction_knockback = 20
export (float) var cooldown_hit = 3.0
var cooldown_h = cooldown_hit
var roll_vector = Vector2.LEFT
enum {
	MOVE,
	ROLL,
	ATTACK,
	KNOCKBACK,
}
var health = 3
var is_attacked = false
var state = MOVE
var velocity = Vector2.ZERO
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitbox
var knockback = Vector2.ZERO
var a_delta = 1.0
func _ready():
	animationTree.active = true
	swordHitbox.knockback_vector = roll_vector

func _physics_process(delta):
	a_delta = delta
	if is_attacked and cooldown_h <= 0:
		health -= 1
		cooldown_h = cooldown_hit
	else:
		cooldown_h -= delta
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state(delta)
		ROLL:
			roll_state(delta)
		KNOCKBACK:
			knockback_state(delta)
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitbox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		velocity = velocity.move_toward(input_vector * max_speed, acceleration * delta)
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta * (abs(velocity.angle_to(input_vector)) / PI) )
	else :
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	if velocity != Vector2.ZERO:
		animationState.travel("Run")
	else:
		animationState.travel("Idle")
	
	velocity = move(velocity)
	if Input.is_action_pressed("roll"):
		state = ROLL 
	if Input.is_action_pressed("attack"):
		state = ATTACK
	if health <= 0:
		GameState._unused_warning = get_tree().change_scene("res://scenes/Death.tscn")
	
func knockback_state(delta):
	
	knockback = knockback.move_toward(Vector2.ZERO, friction_knockback * delta)
	if knockback != Vector2.ZERO:
		animationTree.set("parameters/Run/blend_position", knockback)
		animationTree.set("parameters/Idle/blend_position", knockback)
		knockback = move(knockback)
		animationState.travel("Run")
	else:
		state = MOVE
	
func attack_state(_delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func attack_animation_finish():
	state = MOVE
	
func roll_animation_finish():
	velocity = velocity * 0.7
	state = MOVE


func roll_state(_delta):
	velocity = roll_vector * roll_speed
	animationState.travel("Roll")
	velocity = move(velocity)

func _on_Hurtbox_area_entered(area):
	GameState._unused_warning = move_and_slide(Vector2.ZERO)
	state = KNOCKBACK
	knockback = area.knockback_vector * max_speed_knockback
	is_attacked = true

func launch_atack_sound():
	Fmod.play_one_shot_attached("event:/SFX/Character/SFX_Sword", self)
	

func get_node_type():
	return GameState.Player


func get_class():
	return "Player"
func _on_Hurtbox_area_exited(_area):
	is_attacked = false
