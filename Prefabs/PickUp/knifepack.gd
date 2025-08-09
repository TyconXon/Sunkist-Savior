extends Sprite2D

@export var knifes = 4
var kill_parent = false

func got_callback():
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.ammo += knifes
		Global.knifesObtained += knifes
		if kill_parent:
			get_parent().queue_free()
		queue_free()
	pass # Replace with function body.
