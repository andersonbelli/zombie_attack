extends CharacterBody2D


const SPEED = 300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var _target: Area2D
@onready var _enemy_position: Vector2

var move_strength = 50

func _ready():
	gravity = 0

func enemy_spawn(target: Area2D, enemy_position: Vector2):
	print("CHAMA O PAI" +  str(target == null) +  str(enemy_position == Vector2.ZERO) )
	_target = target
	#_enemy_position = enemy_position
	
	look_at(target.position)
	#$RayCast2D.target_position = _target.position.normalized()
	
	print("spawn! " + str(enemy_position))

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	if collision_mask == 3:
		print("ouch!")
	
	if $RayCast2D.get_collider() == _target:
		$AnimatedSprite2D.animation = "attack"
	else:
		if not $RayCast2D.is_colliding():			
			#velocity = move_strength * Vector2(_target.position.x - 1, _target.position.y - 1)
			#velocity = move_strength * Vector2(_target.position.x - position.x, _target.position.y - 1).normalized()
		
			#look_at(_target.position - position)
			
			position -= _target.position.direction_to(position)
			velocity = move_strength * position.direction_to(_target.position)
			#velocity = move_strength * $RayCast2D.target_position
			
			
			gravity += 1 * move_strength
			#move_and_slide()
			
			var collision = move_and_collide(velocity * delta)
			
			if collision != null:
				if collision.get_collider_shape().get("name") == "collision_bullet":
					var bullet = collision.get_collider()
					
					bullet.hit(collision.get_position())
					
					print("zombie collison " + str(collision.get_collider_shape().get("name")))

