extends Sprite2D

@export var heal = 1

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player" && body.health != body.max_health:
		body.health += heal
		queue_free()
	pass # Replace with function body.
