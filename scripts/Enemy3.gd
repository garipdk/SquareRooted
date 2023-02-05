extends KinematicBody2D

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
var currentDirection = Vector2.ZERO
onready var collisionshape2d = $CollisionShape2D
onready var node2d = $Node2D
var isready = false

func _ready():
	animationTree.active = true
	hitbox.knockback_vector = velocity
	isready = true

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
			
			# L'ennemi3 va changer progressivement de direction.
			# Sa direction à l'instant T dépend donc de sa direction à l'instant T-1
			#   et d'une direction idéal.
			# À chaque instant, on calcule donc la direction idéale qui est la direction
			#   qui s'éloigne au mieux du joueur et des deux murs les plus proches
			# La répartition correspond à la proportion entre la direction T-1 et
			#   la direction idéale.
#			var distBordDroit = GameState.bordDroitCS2D.shape.extents
			if isready:
				var distBordHaut   = max(0, (collisionshape2d.global_position.y - collisionshape2d.shape.height) - (GameState.bordHautCS2D.position.y + GameState.bordHautCS2D.shape.extents.y))
#				print("(%f - %f) - (%f + %f) = %f" % [collisionshape2d.global_position.y,collisionshape2d.shape.height,GameState.bordHautCS2D.position.y,GameState.bordHautCS2D.shape.extents.y, distBordHaut])
				var distBordBas    = max(0, (GameState.bordBasCS2D.position.y - GameState.bordBasCS2D.shape.extents.y) - (collisionshape2d.global_position.y + collisionshape2d.shape.height))
				var distBordGauche = max(0, (collisionshape2d.global_position.x - collisionshape2d.shape.radius) - (GameState.bordGaucheCS2D.position.x + GameState.bordGaucheCS2D.shape.extents.x))
				var distBordDroit  = max(0, (GameState.bordDroitCS2D.position.x - GameState.bordDroitCS2D.shape.extents.x) - (collisionshape2d.global_position.x + collisionshape2d.shape.radius))
			
				var idealDirection = ((global_position - player.global_position).normalized() + ((Vector2(0,1) * max(0,(10 - distBordHaut))) + (Vector2(0,-1) * max(0,(10 - distBordBas))) + (Vector2(1,0) * max(0,(10 - distBordGauche))) + (Vector2(-1,0) * max(0,(10 - distBordDroit)))).normalized()).normalized()
				
				
				var repartition = delta
				var direction = (1-repartition) * currentDirection + repartition * idealDirection
#				var direction = idealDirection
				currentDirection = direction
				
				velocity = velocity.move_toward(direction * max_speed_use, delta * acceleration)
				animationState.travel("Run_en1")
				velocity = move_and_slide(velocity)
		else:
			animationTree.set("parameters/Run_en1/blend_position", velocity)
			animationState.travel("Run_en1")
			
			# Tirer
			
	else:
		player = GameState.player

func _on_Hurtbox_area_entered(area):
	GameState._unused_warning = move_and_slide(Vector2.ZERO)
	knockback = area.knockback_vector * max_speed_knockback

func activate_movement():
	movement = true

func deactivate_movement():
	movement = false
