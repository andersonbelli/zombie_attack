extends CharacterBody2D

class_name PlayerClass

signal on_die

@export var Bullet: PackedScene

@onready var cooldown_timer = $cooldown
@onready var animated_sprite_2d = $AnimatedSprite2D

var bullet: BulletClass
var bullet_speed = 1000

var health = 100

func _process(delta):
	if Input.is_action_just_pressed("space_test"):
		on_hit(8)
	
	var mouse_position = get_viewport().get_mouse_position()

	look_at(mouse_position)
	
	if cooldown_timer.is_stopped():
		if Input.is_action_pressed("shoot"):
			cooldown_timer.start()
			$AnimatedSprite2D.animation = "shooting"
			
			shoot(mouse_position)

func _on_cooldown_timeout():
	$AnimatedSprite2D.animation = "idle"
	cooldown_timer.stop()

func shoot(mouse_position):
	bullet = Bullet.instantiate()
	
	bullet.position = $AnimatedSprite2D/Marker2D.position
	bullet.rotation_degrees = global_rotation
	
	var direction = global_position.direction_to(mouse_position)
	var impulse = direction * 100
	bullet.add_constant_central_force(impulse)
	
	add_child(bullet)
	
func on_hit(damage: int):
	if health <= 0:
		queue_free()
		#var game = get_parent() as GameClass
		on_die.emit()
	
	health -= damage
	
	$AnimatedSprite2D/AnimationPlayer.play("hit_player")
	
	print("player health: " + str(health))
