extends CanvasLayer

signal on_start_game

@onready var start_music = $start_music

func _on_button_start_game_pressed():
	start_music.stop()
	
	on_start_game.emit()
