extends Node2D

class_name GameClass

enum WALLS {LEFT, CENTER, RIGHT}
@export var wall: WALLS = WALLS.CENTER

@onready var wall_center = $walls/AreaWallCenter
@onready var wall_left = $walls/AreaWallLeft
@onready var wall_right = $walls/AreaWallRight

@onready var spawn_timer = $spawn_timer
@onready var path = $mob_spawn/PathFollow2D
@onready var mob_path = $mob_spawn/PathFollow2D

@onready var player: CharacterBody2D = $player

@onready var game_over: CanvasLayer = $game_over
@onready var win_phase: CanvasLayer = $win_phase

@export var Zombie: PackedScene
var zombie: ZombieClass
@export var remaning_zombies_phase := 1

signal wall_hit

func _on_game_over_on_try_again():
	get_tree().reload_current_scene()

func stop_enemy_spawn():
	if not get_tree().get_nodes_in_group("enemy_spawn").is_empty():
		for node in get_tree().get_nodes_in_group("enemy_spawn"):
			node.queue_free()

func _on_player_on_die():
	stop_enemy_spawn()
	game_over.visible = true

func on_win_phase():
	if remaning_zombies_phase == 0 and get_tree().get_nodes_in_group("enemies").is_empty():
		stop_enemy_spawn()
		win_phase.visible = true

func _physics_process(delta):
	on_win_phase()

func _on_spawn_timer_timeout():
	if remaning_zombies_phase > 0:
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
		
		zombie.add_to_group("enemies")
		zombie.enemy_spawn(target, zombie.position)
		
		remaning_zombies_phase -= 1
		add_child(zombie)
