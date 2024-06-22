extends CharacterBody2D


const SPEED = 300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var _target: Area2D
@onready var _enemy_position: Vector2

var move_strength = 50

var heath = 5

func _ready():
	gravity = 0

func enemy_spawn(target: Area2D, enemy_position: Vector2):
	#print("CHAMA O PAI" +  str(target == null) +  str(enemy_position == Vector2.ZERO) )
	_target = target
	#_enemy_position = enemy_position
	
	look_at(target.position)
	#print("spawn! " + str(enemy_position))

func _physics_process(delta):
	var collision
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	#if $RayCast2D.get_collider() == _target:
		#$AnimatedSprite2D.animation = "attack"
	#else:
	if true:
		if not $RayCast2D.is_colliding():
			#velocity = move_strength * Vector2(_target.position.x - 1, _target.position.y - 1)
			#velocity = move_strength * Vector2(_target.position.x - position.x, _target.position.y - 1).normalized()
		
			#look_at(_target.position - position)
			
			position -= _target.position.direction_to(position)
			velocity = move_strength * position.direction_to(_target.position)
			
			gravity += 1 * move_strength
			
			collision = move_and_collide(velocity * delta)
			
			if collision != null:
				if collision.get_collider_shape().get("name") == "CollisionBullet":
					print("ouch!" + str(self.get_rid()))
					var bullet = collision.get_collider()
					
					#print("colision at =>>> " + str(collision.get_position()))
					bullet.hit(collision.get_position())
					
					if heath != 0:
						$AnimatedSprite2D/AnimationPlayer.play("hit")
						heath -= 1
					else:
						queue_free()
		else:
			$AnimatedSprite2D.animation = "attack"
			
			print("COLISION -> " + str($CollisionShape2D.position))
			
			if collision != null:
				if collision.get_collider_shape().get("name") == "CollisionBullet":
					print("ouch!" + str(self.get_rid()))
					var bullet = collision.get_collider()
					
					#print("colision at =>>> " + str(collision.get_position()))
					bullet.hit(collision.get_position())
					
					if heath != 0:
						$AnimatedSprite2D/AnimationPlayer.play("hit")
						heath -= 1
					else:
						queue_free()

