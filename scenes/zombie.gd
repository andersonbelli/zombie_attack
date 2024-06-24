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

#func _process(delta):
	#look_at(_target.position)

func enemy_spawn(target: Area2D, enemy_position: Vector2):
	_target = target
	look_at(target.position)

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
		
	
