extends Node2D

func _input(event):
	if event.is_action_pressed("pause"):
		get_tree().paused = !get_tree().paused
		visible = !visible


func _on_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Main Menu.tscn")
	
	pass # Replace with function body.
