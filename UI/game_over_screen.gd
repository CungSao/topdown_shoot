extends CanvasLayer

@onready var title = $PanelContainer/MarginContainer/Rows/Title


func set_title(win:bool):
	if win:
		title.text = 'YOU WIN'
		title.modulate = Color.GREEN
	else:
		title.text = 'YOU LOSE'
		title.modulate = Color.RED


func _on_restart_button_down():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main.tscn")


func _on_quit_button_down():
	get_tree().quit()


func _on_main_menu_button_down():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://UI/main_menu_screen.tscn")
