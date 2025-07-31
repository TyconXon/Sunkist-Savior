extends Area2D

var velocity = Vector2.RIGHT
var positionToAttack = null
var stabbed = false
var already_dropped = false
@export var damage = 1
@export var speed = 10

func _ready():
	if positionToAttack == null:
		positionToAttack = get_global_mouse_position()
	velocity = velocity.rotated(positionToAttack.angle_to_point(position))
	

func _physics_process(delta: float) -> void:
	if !stabbed:
		position += transform.x * speed


func _on_body_entered(body: Node2D) -> void:
	
	if self.is_in_group("friendly"):
		if !body.is_in_group("friendly"):
			#queue_free()
			$CollisionShape2D.disabled = true
			self.velocity = Vector2.ZERO
			stabbed = true
			damage = 0
			self.self_modulate = Color(100,100,100,100)
			self.reparent(body)
			$AnimationPlayer.play("fade_out")
			$DeletionTimer.start()
			
			if(body is TileMapLayer and not already_dropped):
				var instance = load('res://Prefabs/PickUp/knifepack.tscn').instantiate()
				instance.knifes = 1
				instance.visible = false
				instance.kill_parent = true
				add_child(instance)
				already_dropped = true
	else:
		if !body.is_in_group("enemy"):
			queue_free()
			pass


func _on_deletion_timer_timeout() -> void:
	queue_free()
	pass # Replace with function body.


func _on_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
