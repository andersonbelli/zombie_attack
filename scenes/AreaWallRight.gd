extends WallsClass

#extends Area2D
#
#class_name AreaWallRightClass
#
#signal on_hit


func _on_on_hit():
	$AnimationPlayer.play("hit")
