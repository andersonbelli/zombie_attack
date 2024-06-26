extends Node2D

class_name GameClass

enum WALLS {LEFT, CENTER, RIGHT}
@export var wall: WALLS = WALLS.CENTER

@onready var mob_path = $mob_spawn/PathFollow2D

@onready var wall_center = $walls/AreaWallCenter
@onready var wall_left = $walls/AreaWallLeft
@onready var wall_right = $walls/AreaWallRight

@onready var player: CharacterBody2D = $player
@onready var spawn_timer = $spawn_timer
@onready var path = $mob_spawn/PathFollow2D
@onready var game_over: CanvasLayer = $game_over

@export var Zombie: PackedScene
var zombie: ZombieClass

signal wall_hit

func _on_game_over_on_try_again():
	get_tree().reload_current_scene()

	
func _on_player_on_die():
	game_over.visible = true
	
	for node in get_tree().get_nodes_in_group("enemy_spawn"):
		remove_child(node)

func _on_spawn_timer_timeout():
	zombie = Zombie.instantiate()
	
	path.progress = randf()
	zombie.position = path.position
	
	var target = wall_center
	var wall_to_attack = randi_range(0, 2)
	
	wall = wall_to_attack
	
	
	match wall:
		WALLS.CENTER:
			target = wall_center
		WALLS.LEFT:
			target = wall_left
		WALLS.RIGHT:
			target = wall_right

	if target == null:
		target = player
	
	mob_path.progress = randf_range(0, 1100)
	
	var direction = mob_path.rotation + PI / 2
	
	if mob_path.position.x > 0:
		zombie.position.x = mob_path.position.x * (-1)
		zombie.position.y = mob_path.position.y
	elif mob_path.position.y > 0:
		zombie.position.x = mob_path.position.x
		zombie.position.y = mob_path.position.y * (-1)
	else:
		zombie.position = mob_path.position
	
	direction += randf_range(-PI / 4, PI / 4)
	zombie.rotation = direction
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	
	zombie.enemy_spawn(target, zombie.position)
	
	add_child(zombie)
