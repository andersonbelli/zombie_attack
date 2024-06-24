extends CharacterBody2D

class_name ZombieClass

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var ray_cast = $Area2D/CollisionShape2D/RayCast2D
@onready var hit_cooldown_timer = $HitCooldownTimer
@onready var delay_hit_timer = $DelayHitTimer

var _target
var _enemy_position: Vector2

var move_strength = 50
var health = 5
var zombie_strength = 8

func _ready():
	gravity = 0

#func _process(delta):
	#look_at(_target.position)

func enemy_spawn(target, enemy_position: Vector2):
	_target = target
	look_at(target.position)
	position.angle_to(_target.position.direction_to(position))

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if ray_cast.is_colliding():
		if ray_cast.get_collider() != null:
			#print("raycast + " + str(ray_cast.get_collider().name).to_lower())
			
			if str(ray_cast.get_collider().name).to_lower().contains("wall"):
				var colission_wall = ray_cast.get_collider()
				if _target == null:
					_target = colission_wall
					position.angle_to(_target.position.direction_to(position))
				
				_on_game_wall_hit(colission_wall)
			elif str(ray_cast.get_collider().name).to_lower().contains("player"):
				#look_at(ray_cast.target_position)
				_on_player_hit()
	else:
		if _target == null:
			_target = get_parent().find_child("player")
			
			#print("player focus ==== " + str(_target))
			
			#rotation = position.angle_to(_target.position) + randf_range(-PI / 4, PI / 4)
			var direction = (position.angle_to(_target.position)) + PI / 2
			direction += randf_range(-PI / 4, PI / 4)
			rotation = direction
			#look_at(direction)
			position.angle_to(_target.position.direction_to(position))
			
			#ray_cast.target_position = position.direction_to(_target.position)
			#ray_cast.target_position = _target.position - position
			
			#print("raycast + " + str(ray_cast.get_collider().name).to_lower())
			
			$AnimatedSprite2D.animation = "move"
		
		print("player focus ==== " + str(_target))
		
		position -= _target.position.direction_to(position)
		velocity = move_strength * position.direction_to(_target.position)
		
		gravity += 1 * move_strength
	
		position.angle_to(_target.position)
		
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
	#print("hit_cooldown_timer + " + str(hit_cooldown_timer.time_left))
	
	if hit_cooldown_timer.time_left < 0.7:
		print("delay_hit_timer + " + str(delay_hit_timer.time_left))
		delay_hit_timer.autostart = true
		
		if delay_hit_timer.time_left < 1:
			delay_hit_timer.start()
			$AnimatedSprite2D.animation = "idle"
		else:
			$AnimatedSprite2D.animation = "attack"
			
			wall = wall as WallsClass
		
			wall.health -= zombie_strength
			wall.on_hit()
			
			if wall.health > 0:
				wall.health - zombie_strength
				print("wall hit = " + str(wall.health))
				
				hit_cooldown_timer.start()
			else:
				$AnimatedSprite2D.animation = "idle"
				_target = null
				wall.queue_free()

func _on_player_hit():
	print("player!!!")
	$AnimatedSprite2D.animation = "attack"
