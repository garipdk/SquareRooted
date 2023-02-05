extends Enemies

var knockback = Vector2.ZERO
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var hitbox = $Hitbox

export (int) var max_speed = 300
export (int) var max_speed_knockback = 600
export (int) var acceleration = 650
export (int) var friction = 2000
export (int) var friction_knockback = 200

var movement = false

var max_speed_use = max_speed
var velocity = Vector2.ZERO
var player = null
func _ready():
	animationTree.active = true
	hitbox.knockback_vector = velocity

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, friction_knockback * delta)
	if knockback != Vector2.ZERO:
		animationTree.set("parameters/Run_en1/blend_position", knockback)
		animationTree.set("parameters/Idle_en1/blend_position", knockback)
		knockback = move_and_slide(knockback)
	elif player != null:
		if movement:
			hitbox.knockback_vector = velocity
			animationTree.set("parameters/Run_en1/blend_position", velocity)
			var direction = (player.global_position - global_position).normalized()
			velocity = velocity.move_toward(direction * max_speed_use, delta * acceleration)
			animationState.travel("Run_en1")
			velocity = move_and_slide(velocity)
		else:
			animationTree.set("parameters/Run_en1/blend_position", velocity)
			animationState.travel("Run_en1")
			#velocity = move_and_slide(Vector2.ZERO)
	else:
		player = GameState.player
	
	if knockback != Vector2.ZERO:
		is_hited = true
	else:
		is_hited = false

func _on_Hurtbox_area_entered(area):
	GameState._unused_warning = move_and_slide(Vector2.ZERO)
	knockback = area.knockback_vector * max_speed_knockback

func activate_movement():
	movement = true

func deactivate_movement():
	movement = false

func get_node_type():
	return GameState.Enemy3


func _on_Hitbox_Fusion_area_entered(area):
	if spawner.fusion_area_entered(self, area):
		get_parent().remove_child(area.get_parent())
		area.queue_free()
		queue_free()
