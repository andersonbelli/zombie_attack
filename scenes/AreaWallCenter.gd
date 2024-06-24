extends WallsClass

#class_name AreaWallCenterClass
#
#signal on_hit
#
#var health = 50

@onready var animation_player = $Sprite2D/AnimationPlayer

func on_hit():
	animation_player.play("hit")
	print("HIT ON CENTER WALL!!")
