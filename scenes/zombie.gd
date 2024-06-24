extends CharacterBody2D

class_name ZombieClass

const SPEED = 300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var _target: Area2D
@onready var _enemy_position: Vector2
@onready var ray_cast = $Area2D/CollisionShape2D/RayCast2D

var move_strength = 50
var health = 5
var collision

func _ready():
	gravity = 0

func enemy_spawn(target: Area2D, enemy_position: Vector2):
	#print("CHAMA O PAI" +  str(target == null) +  str(enemy_position == Vector2.ZERO) )
	_target = target
	#_enemy_position = enemy_position
	
	look_at(target.position)
	#print("spawn! " + str(enemy_position))

#func _process(delta):
	#if collision != null:
		##print("collision " + str(collision.get_collider_shape()))
		#if collision.get_collider_shape().get("name") == "CollisionBullet":
			##print("ouch!" + str(self.get_rid()))
			#var bullet = collision.get_collider()
			#
			##print("colision at =>>> " + str(collision.get_position()))
			#bullet.hit(collision.get_position())
			#
			#if heath != 0:
				#$AnimatedSprite2D/AnimationPlayer.play("hit")
				#heath -= 1
			#else:
				#queue_free()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if ray_cast.is_colliding():
		print("wall + " + str(ray_cast.get_collider().name))
		_on_game_wall_hit()
	else:
		position -= _target.position.direction_to(position)
		velocity = move_strength * position.direction_to(_target.position)
		
		gravity += 1 * move_strength
		
		collision = move_and_collide(velocity * delta)

func _on_area_2d_body_entered(body):
	if str(body.get_children()).contains("Bullet"):
		var bullet: BulletClass = body
		bullet.hit(self, body.position)
		
		print("health " + str(health))
		$AnimatedSprite2D/AnimationPlayer.play("hit")
		
		if health == 0:
			queue_free()


func _on_game_wall_hit():
	#print("asd")
	if $AnimatedSprite2D.animation != "attack":
		$AnimatedSprite2D.animation = "attack"
	pass
