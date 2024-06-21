extends RigidBody2D

@onready var raycast:RayCast2D = $Area2D/RayCast2D

@onready var _target: Area2D
@onready var _enemy_position: Vector2

var mu_static = 0.8  # friction coefficients
var mu_moving = 0.5  # pushing something moving is easier

var move_strength = 50

var applied_forces: Vector2 = Vector2(0, 0)

func add_force_for_frame(force: Vector2):
	applied_forces += force
	add_constant_force(force)

func _ready() -> void:
	self.gravity_scale = 0

func _physics_process(delta: float) -> void:
	add_force_for_frame(-applied_forces) # wipe out previous forces

	if self.linear_velocity.length() == 0:
		self.add_force_for_frame(- mass * mu_static * self.linear_velocity.normalized())
	else:
		self.add_force_for_frame(- mass * mu_moving * self.linear_velocity.normalized())
	
func enemy_spawn(target: Area2D, enemy_position: Vector2):
	print("CHAMA O PAI" +  str(target == null) +  str(enemy_position == Vector2.ZERO) )
	_target = target
	#_enemy_position = enemy_position
	
	look_at(target.position)
