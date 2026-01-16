extends Control

func _ready():
	visible = false

func show_game_over():
	visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	print("game over")

func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
	print("Restart knop")

func _on_quit_pressed() -> void:
	get_tree().quit()
	print("quit knop")
