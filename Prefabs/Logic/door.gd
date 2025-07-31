extends AnimatedSprite2D

@export var open = false:
	set(value):
		open = value
		if open:
			$StaticBody2D.collision_layer = 0
			animation = "open"
			modulate = Color(1.0,1.0,1.0, 0.5)
		if !open:
			animation = "closed"
			$StaticBody2D.collision_layer = 1
			modulate = Color(1.0,1.0,1.0, 1.0)
			
