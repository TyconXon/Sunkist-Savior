extends Sprite2D

#apple
@export_file var NEXT_SCENE = "res://Debug.tscn" 

func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body.name == "Player"):
		get_tree().change_scene_to_file(NEXT_SCENE)
	pass # Replace with function body.
