extends CharacterBody2D

const BULLET = preload("res://scenes/bullet.tscn")

var bullet_speed = 1000

func _process(delta):
	var mouse_position = get_viewport().get_mouse_position()
	look_at(mouse_position)
	
	if Input.is_action_pressed("shoot"):
		var bullet = BULLET.instantiate()
		
		
		
		bullet.position = get_position_delta()
		
		bullet.rotation_degrees = rotation_degrees
		bullet.apply_impulse(Vector2(),Vector2(bullet_speed, 0).rotated(rotation))
		get_tree().get_root().add_child(bullet)
		
