@tool
extends Line2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if get_parent().thingToModify != null and get_parent().thingToModify is Node2D:
		if get_parent().thingToModify.position != null:
			points[1] = to_local(get_parent().thingToModify.position)
