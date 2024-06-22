extends RigidBody2D

class_name BulletClass

func _get_class(): 
	return "BulletClass"
func _is_class(name):
	return name == "BulletClass"

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

func hit(_hit_position):
	bullet_sprite.visible = false
	animated_sprite.visible = true
	animated_sprite.z_index = 5
	
	animated_sprite.play("hit_enemy")
	
	#owner = get_tree().root.get_child(0)
	
	#print("owner ------ "+ str(owner))
	
	
	linear_velocity= Vector2.ZERO
	constant_force = Vector2.ZERO
	freeze = true
	
	collision_bullet.disabled = true
	
	#animated_sprite.animation = "hit_enemy"
	
	hit_position = _hit_position
	#animated_sprite.position = position.direction_to(_hit_position)
	#position = _hit_position
	
	#animated_sprite.play("hit_enemy")
	

func _on_animated_sprite_2d_animation_finished():
	#print("hitei XD + " + str(hit_position))
	
	queue_free()
	get_parent().remove_child(self)

func _on_animated_sprite_2d_animation_changed():
	position = hit_position
