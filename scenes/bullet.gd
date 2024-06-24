extends RigidBody2D

class_name BulletClass

@onready var animated_sprite = $HitAnimatedSprite
@onready var collision_bullet = $CollisionBullet
@onready var bullet_sprite = $BulletSprite

var hit_position

func _ready():
	#print("bullet position = " + str(position))
	#hit_position = position
	animated_sprite.visible = false

func _physics_process(delta):
	#if hit_position != null:
		#position = hit_position
	pass

func hit(zombie: ZombieClass , _hit_position):
	call_deferred("reparent", zombie)
	collision_bullet.call_deferred("set_disabled", true)
	collision_bullet.rotation = 0
	
	hit_position = _hit_position
	
	
	bullet_sprite.visible = false
	rotation = 0
	angular_velocity = 0
	animated_sprite.visible = true
	animated_sprite.z_index = 5

	call_deferred("set_freeze_enabled", true)
	
	linear_velocity = linear_velocity / 2000
	constant_force =  constant_force / 1000
	
	animated_sprite.play("hit_enemy")
	
	if get_parent().name != "player":
		zombie.health -= 1

func _on_animated_sprite_2d_animation_finished():
	queue_free()

func _on_animated_sprite_2d_animation_changed():
	position = hit_position
