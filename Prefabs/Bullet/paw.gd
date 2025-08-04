extends Area2D

var velocity = Vector2.RIGHT
@export var damage = 0.5

func _ready():
	velocity = velocity.rotated(get_global_mouse_position().angle_to_point(position))
	$DeletionTimer.start()
	$AnimationPlayer.play("fade_out")
	position += transform.x * 10
	$Sprite2D.global_rotation = 0

func _physics_process(delta: float) -> void:
	position += transform.x * 2

func _on_deletion_timer_timeout() -> void:
	queue_free()



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.stun(0.75, 10)
