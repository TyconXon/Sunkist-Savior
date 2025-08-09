extends AnimationPlayer

func _ready() -> void:
	connect("animation_finished", restart)
	
func restart(anim):
	play(anim)
