extends CanvasLayer


func _on_play_button_down():
	get_tree().change_scene_to_file("res://main.tscn")


func _on_quit_button_down():
	get_tree().quit()
