extends WallsClass

#class_name AreaWallLeftClass
#
#signal on_hit


func _on_on_hit():
	$AnimationPlayer.play("hit")
