extends CharacterBody2D

@export var Bullet: PackedScene

var bullet: RigidBody2D
var bullet_speed = 1000

func _ready():
	bullet = Bullet.instantiate()

func _physics_process(delta):
	bullet = Bullet.instantiate()
	print("player: " + str(self.rotation_degrees))

func _process(delta):
	
	var mouse_position = get_viewport().get_mouse_position()
	look_at(mouse_position)
	
	if Input.is_action_pressed("shoot"):
		#var bullet = Bullet.instantiate()
		
		
		# bullet.rotation_degrees = position.angle_to(mouse_position)
		
		# bullet.rotate(position.angle())
		
		var button_angle = position.angle_to(mouse_position)
		var player_rotation = rotation
		var player_rotation_degress = rotation_degrees
		
		var _rotation = global_rotation_degrees
		var _rotation1 = global_rotation
		var _rotation2 = global_position
		var _rotation3 = mouse_position
		var _rotation4 = mouse_position.x
		
		bullet.position = position
		bullet.rotation_degrees = rotation_degrees
		#bullet.rotate(rotation_degrees * -1)
		
		bullet.get_angle_to(mouse_position)
		
		var direction = global_position.direction_to(mouse_position) # this is a unit vector (length 1)
		var impulse = direction * 100
		#bullet.add_constant_central_force(Vector2(10, 0) * delta)
		
		#bullet.add_constant_central_force(Vector2(rotation_degrees, rotation * bullet_speed))
		#bullet.apply_impulse(Vector2(impulse, mouse_position.y * -1), Vector2(0, position.y * -1 * bullet_speed).rotated(rotation))
		bullet.add_constant_central_force(impulse)
		
		owner.add_child(bullet)
		
		#get_tree().get_root().add_child(bullet)
		
