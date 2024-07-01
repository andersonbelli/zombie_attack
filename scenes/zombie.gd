extends CharacterBody2D

class_name ZombieClass

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var ray_cast = $Area2D/CollisionShape2D/RayCast2D
@onready var hit_cooldown_timer = $HitCooldownTimer
@onready var delay_hit_timer = $DelayHitTimer
@onready var enemy_hit_sfx = $enemy_hit_sfx

var _target
var _enemy_position: Vector2

var move_strength = 50
var health = 5
var zombie_strength = 8

func _ready():
	gravity = 0

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
			var colission_target = ray_cast.get_collider()
			
			if str(ray_cast.get_collider().name).to_lower().contains("wall"):
				if _target == null:
					_target = colission_target
					position.angle_to(_target.position.direction_to(position))
				
				_on_game_wall_hit(colission_target)
			elif str(ray_cast.get_collider().name).to_lower().contains("player"):
				print(ray_cast.get_collider())
				_target = get_parent().get_node("player_node").get_node("player")
				
				_on_player_hit()
	else:
		if get_parent().find_child("player") != null:
			if _target == null:
				_target = get_parent().find_child("player")
				
				var direction = (position.angle_to(_target.position)) + PI / 2
				direction += randf_range(-PI / 4, PI / 4)
				rotation = direction
				position.angle_to(_target.position.direction_to(position))
				
				$AnimatedSprite2D.animation = "move"
		else:
			_target = self
			set_process(false)
			set_physics_process(false)
			$AnimatedSprite2D.animation = "idle"
		
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
		
		$AnimatedSprite2D/AnimationPlayer.play("hit")
		enemy_hit_sfx.play()
		
		if health == 0:
			queue_free()


func _on_game_wall_hit(wall):
	if hit_cooldown_timer.time_left < 0.7:
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
				
				hit_cooldown_timer.start()
			else:
				$AnimatedSprite2D.animation = "idle"
				_target = null
				wall.queue_free()

func _on_player_hit():
	var player = _target as PlayerClass
	player.on_hit(zombie_strength)
	$AnimatedSprite2D.animation = "attack"
