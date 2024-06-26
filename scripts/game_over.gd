extends CanvasLayer

signal on_try_again

func _on_button_try_again_pressed():
	on_try_again.emit()
