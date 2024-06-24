extends WallsClass

@onready var animation_player = $Sprite2D/AnimationPlayer

func on_hit():
	animation_player.play("hit")
	print("HIT ON LEFT WALL!!")
