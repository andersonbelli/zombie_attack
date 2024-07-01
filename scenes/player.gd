extends CharacterBody2D

class_name PlayerClass

signal on_die

@export var Bullet: PackedScene

@onready var cooldown_timer = $cooldown
@onready var audio_stream_player = $AudioStreamPlayer

@onready var animated_sprite = $AnimatedSprite2D
@onready var marker = $AnimatedSprite2D/Marker2D
@onready var animation_player = $AnimatedSprite2D/AnimationPlayer

@onready var light_occluder = $LightOccluder2D
@onready var point_light_2d = $PointLight2D

var bullet: BulletClass
var bullet_speed = 1000

var health = 100

func _physics_process(delta):
	light_occluder.visible = false
	point_light_2d.visible = false
	pass

func _process(delta):
	if Input.is_action_just_pressed("space_test"):
		on_hit(8)
	
	var mouse_position = get_viewport().get_mouse_position()

	look_at(mouse_position)
	
	if cooldown_timer.is_stopped():
		if Input.is_action_pressed("shoot"):
			cooldown_timer.start()
			animated_sprite.animation = "shooting"
			
			shoot(mouse_position)

func _on_cooldown_timeout():
	animated_sprite.animation = "idle"
	cooldown_timer.stop()

func shoot(mouse_position):
	audio_stream_player.play()
	
	light_occluder.visible = true
	point_light_2d.visible = true
	
	bullet = Bullet.instantiate()
	
	bullet.position = marker.position
	bullet.rotation_degrees = global_rotation
	
	var direction = global_position.direction_to(mouse_position)
	var impulse = direction * 100
	bullet.add_constant_central_force(impulse)
	
	add_child(bullet)
	
func on_hit(damage: int):
	if health <= 0:
		queue_free()
		on_die.emit()
	
	health -= damage
	
	animation_player.play("hit_player")
	
	print("player health: " + str(health))
