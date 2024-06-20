extends CharacterBody2D

const BULLET = preload("res://scenes/bullet.tscn")

var bullet_speed = 1000

func _process(delta):
	var mouse_position = get_viewport().get_mouse_position()
	look_at(mouse_position)
	
	if Input.is_action_pressed("shoot"):
		var bullet = BULLET.instantiate()
		bullet.position = get_position_delta()
		# bullet.rotation_degrees = rotation_degrees
		
		bullet.rotation_degrees = mouse_position.angle_to(position)
		
		var button_angle = position.angle_to(mouse_position)
		
		# bullet.apply_central_force(Vector2(),Vector2(bullet_speed, 0).rotated(button_angle))
		
		var direction = global_position.direction_to(global_position) # this is a unit vector (length 1)
		var impulse = direction * 100
		bullet.add_constant_central_force(Vector2(10, 0) * delta)
		#bullet.apply_central_impulse(impulse)
		
		get_tree().get_root().add_child(bullet)
		
