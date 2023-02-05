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

var movement = false

var max_speed_use = max_speed
var velocity = Vector2.ZERO
var player = null
var currentDirection = Vector2.ZERO
onready var collisionshape2d = $CollisionShape2D
var isready = false

var reloadTime = 3.0
var reloading = reloadTime
var aimingTime = 0.5
var aiming = aimingTime

func _ready():
	animationTree.active = true
	hitbox.knockback_vector = velocity
	isready = true

func _physics_process(delta):
	reloading -= delta
	knockback = knockback.move_toward(Vector2.ZERO, friction_knockback * delta)
	if knockback != Vector2.ZERO:
		aiming = aimingTime
		animationTree.set("parameters/Run_en1/blend_position", knockback)
		animationTree.set("parameters/Idle_en1/blend_position", knockback)
		knockback = move(knockback)
	elif player != null:
		if movement:
			aiming = aimingTime
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
				var distBordHaut   = max(0, (collisionshape2d.global_position.y - collisionshape2d.shape.height) - (spawner.get_parent().get_child(1).position.y + spawner.get_parent().get_child(1).get_child(0).shape.extents.y))
#				print("(%f - %f) - (%f + %f) = %f" % [collisionshape2d.global_position.y,collisionshape2d.shape.height,GameState.bordHautCS2D.position.y,GameState.bordHautCS2D.shape.extents.y, distBordHaut])
				var distBordBas    = max(0, (spawner.get_parent().get_child(2).position.y - spawner.get_parent().get_child(2).get_child(0).shape.extents.y) - (collisionshape2d.global_position.y + collisionshape2d.shape.height))
				var distBordGauche = max(0, (collisionshape2d.global_position.x - collisionshape2d.shape.radius) - (spawner.get_parent().get_child(3).position.x + spawner.get_parent().get_child(3).get_child(0).shape.extents.x))
				var distBordDroit  = max(0, (spawner.get_parent().get_child(4).position.x - spawner.get_parent().get_child(4).get_child(0).shape.extents.x) - (collisionshape2d.global_position.x + collisionshape2d.shape.radius))
			
				var idealDirection = ((global_position - player.global_position).normalized() + ((Vector2(0,1) * max(0,(10 - distBordHaut))) + (Vector2(0,-1) * max(0,(10 - distBordBas))) + (Vector2(1,0) * max(0,(10 - distBordGauche))) + (Vector2(-1,0) * max(0,(10 - distBordDroit)))).normalized()).normalized()
				
				var repartition = delta
				var direction = (1-repartition) * currentDirection + repartition * idealDirection
#				var direction = idealDirection
				currentDirection = direction
				
				velocity = velocity.move_toward(direction * max_speed_use, delta * acceleration)
				animationState.travel("Run_en1")
				velocity = move(velocity)
		else:
			animationTree.set("parameters/Run_en1/blend_position", velocity)
			animationState.travel("Run_en1")
			
			# Tirer
			if reloading == 0:
				aiming -= delta
			if aiming == 0:
				shot()
				reloading = reloadTime
				aiming = aimingTime
	else:
		player = GameState.player
	
	if knockback != Vector2.ZERO:
		is_hited = true
	else:
		is_hited = false

func _on_Hurtbox_area_entered(area):
	GameState._unused_warning = move(Vector2.ZERO)
	knockback = area.knockback_vector * max_speed_knockback

func activate_movement():
	movement = true

func deactivate_movement():
	movement = false

func shot():
	var directionDuTir = player.global_position - global_position
	spawner.spawner_missil(global_position,directionDuTir,10)

func get_node_type():
	return GameState.Enemy3


func _on_Hitbox_Fusion_area_entered(area):
	if spawner.fusion_area_entered(self, area):
		get_parent().remove_child(area.get_parent())
		area.queue_free()
		queue_free()
