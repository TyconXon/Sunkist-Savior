extends Sprite2D

@export var increase_amount = 100

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.speed += increase_amount
		queue_free()
	pass # Replace with function body.
