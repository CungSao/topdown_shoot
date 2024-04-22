extends CanvasLayer

func _input(event):
	if event.is_action_released("ui_accept"):
		get_tree().paused = !get_tree().paused
