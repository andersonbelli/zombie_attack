extends CharacterBody2D

@export var Bullet: PackedScene

var bullet: RigidBody2D
var bullet_speed = 1000

func _ready():
	bullet = Bullet.instantiate()

func _physics_process(delta):
	bullet = Bullet.instantiate()

func _process(delta):
	var mouse_position = get_viewport().get_mouse_position()
	look_at(mouse_position)
	
	if $cooldown.is_stopped():
		if Input.is_action_pressed("shoot"):
			$cooldown.start()
			
			bullet.position = $AnimatedSprite2D/Marker2D.position
			
			#bullet.rotation_degrees = rotation_degrees
			bullet.rotation_degrees = global_rotation
			
			var direction = global_position.direction_to(mouse_position)
			var impulse = direction * 100
			bullet.add_constant_central_force(impulse)
			
			#owner.add_child(bullet)
			add_child(bullet)


func _on_cooldown_timeout():
	$cooldown.stop()
