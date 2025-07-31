extends Sprite2D

@export var increase_amount = 1

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.max_health += 1
		queue_free()
	pass # Replace with function body.
