extends RigidBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var collision_bullet = $collision_bullet
@onready var bullet = $Bullet

var hit_position

func _ready():
	print("position = " + str(position))
	hit_position = position
	animated_sprite.visible = false

func hit(_hit_position):
	animated_sprite.z_index = 5
	linear_velocity= Vector2.ZERO
	constant_force = Vector2.ZERO
	freeze = true
	
	hit_position = _hit_position
	
	collision_bullet.disabled = true
	
	#animated_sprite.animation = "hit_enemy"
	bullet.visible = false
	animated_sprite.visible = true
	
	animated_sprite.play("hit_enemy")
	

func _on_animated_sprite_2d_animation_finished():
	print("hitei XD + " + str(animated_sprite.is_playing()))
	get_parent().remove_child(self)

func _on_animated_sprite_2d_animation_changed():
	position = hit_position
