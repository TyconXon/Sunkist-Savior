extends Area2D

var velocity = Vector2.RIGHT
@export var damage = 0.5
var givenAngle = null

func _ready():
	if givenAngle == null:
		velocity = velocity.rotated(get_global_mouse_position().angle_to_point(position))
	else:
		velocity = velocity.rotated(givenAngle.angle_to_point(Vector2.ZERO))
	$DeletionTimer.start()
	$AnimationPlayer.play("fade_out")
	position += transform.x * 10
	$Sprite2D.global_rotation = 0

func _physics_process(delta: float) -> void:
	position += transform.x * 2 * delta * 50

func _on_deletion_timer_timeout() -> void:
	queue_free()



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.stun(0.75, 10)

func _on_area_entered(area: Area2D) -> void:
	if $DeletionTimer.time_left > $DeletionTimer.wait_time - 0.1:
		if not area.is_in_group("friendly") and area.is_in_group("bullet"):
			area.remove_from_group("enemy")
			area.add_to_group("friendly")
			print('a')
			area.speed *= 1.5
			area.damage *= 0.75
			area.rotate(PI)
			area.modulate = Color.YELLOW
			Global.hitstop(0.5, Color.YELLOW)
			area.projectileboosted = true
		elif area.is_in_group("friendly") and area.is_in_group("bullet") and not area.projectileboosted:
			if !area.stabbed:
				area.modulate = Color.RED
				area.speed *= 2
				area.damage *= 2.0
				Global.hitstop(0.25, Color.RED)
				area.projectileboosted = true
				
			else:
				area.stabbed = false
				area.reparent(area.get_parent().get_parent())
				area.damage *= 0.5
				area.projectileboosted = true
				
