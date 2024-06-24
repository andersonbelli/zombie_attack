extends CharacterBody2D

class_name ZombieClass

const SPEED = 300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var _target: Area2D
@onready var _enemy_position: Vector2
@onready var ray_cast = $Area2D/CollisionShape2D/RayCast2D
@onready var hit_cooldown_timer = $HitCooldownTimer
@onready var delay_hit_timer = $DelayHitTimer

var move_strength = 50
var health = 5
var zombie_strength = 8

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
		#print("wall + " + str(ray_cast.get_collider()))
		#print("wall + " + str(ray_cast.get_collider().get_methods()))
	
		if ray_cast.get_collider() != null:
			if str(ray_cast.get_collider().name).to_lower().contains("wall"):
				var colission_wall = ray_cast.get_collider()
				_on_game_wall_hit(colission_wall)
	else:
		position -= _target.position.direction_to(position)
		velocity = move_strength * position.direction_to(_target.position)
		
		gravity += 1 * move_strength
		
		move_and_collide(velocity * delta)
		_enemy_position = position

func _on_area_2d_body_entered(body):
	if str(body.get_children()).contains("Bullet"):
		var bullet: BulletClass = body
		bullet.hit(self, body.position)
		
		#print("health " + str(health))
		$AnimatedSprite2D/AnimationPlayer.play("hit")
		
		if health == 0:
			queue_free()


func _on_game_wall_hit(wall):
	#print("wall + " + str(wall_name.name))
	
	$AnimatedSprite2D.animation = "attack"
	
	if hit_cooldown_timer.is_stopped():
		print("hit_cooldown_timer + " + str(delay_hit_timer.time_left))
		delay_hit_timer.autostart = true
		
		if delay_hit_timer.is_stopped():
			delay_hit_timer.start()
			$AnimatedSprite2D.animation = "idle"
		else:
			wall = wall as WallsClass
		
			wall.health -= zombie_strength
			wall.on_hit()
			
			if wall.health > 0:
				wall.health - zombie_strength
				print("wall hit = " + str(wall.health))
				
				hit_cooldown_timer.start()
			else:
				wall.queue_free()
		
	#match wall.name:
		#"AreaWallCenter":
			#print("center")
			#
		#"AreaWallRight":
			#print("right")
			#
		#"AreaWallLeft":
			#print("left")
	
	#if $AnimatedSprite2D.animation != "attack":
		#$AnimatedSprite2D.animation = "attack"
		
	
