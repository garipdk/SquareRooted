extends KinematicBody2D

export (int) var max_speed = 500
export (int) var acceleration = 750
export (int) var friction = 2000
var velocity = Vector2.ZERO
enum {
	MOVE,
	ROLL,
	ATTACK,
}
var state = MOVE
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
func _ready():
	animationTree.active = true

func _process(delta):
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state(delta)
		ROLL:
			roll_state(delta)
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		velocity = velocity.move_toward(input_vector * max_speed, acceleration * delta)
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta * (abs(velocity.angle_to(input_vector)) / PI) )
	else :
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	if velocity != Vector2.ZERO:
		animationState.travel("Run")
	else:
		animationState.travel("Idle")
	velocity = move_and_slide(velocity)
	
	if Input.is_action_pressed("attack"):
		state = ATTACK 
		
func attack_state(_delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func attack_animation_finish():
	state = MOVE
	
func roll_state(_delta):
	pass
