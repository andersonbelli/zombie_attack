extends CanvasLayer

signal on_start_game

func _on_button_try_again_pressed():
	on_start_game.emit()
