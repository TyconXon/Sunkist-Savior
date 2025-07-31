extends Area2D

var velocity = Vector2.RIGHT
var positionToAttack = null
var stabbed = false
var already_dropped = false
var returning = false
@export var damage = 1
@export var stun = true
@export var speed = 10
@export var deletionTime = 10
@onready var returnTime = deletionTime*0.5
@export var reactsToWalls = false

func _ready():
	if positionToAttack == null:
		positionToAttack = get_global_mouse_position()
	velocity = velocity.rotated(positionToAttack.angle_to_point(position))
	$ReturnTimer.start(returnTime)
	$DeletionTimer.start(deletionTime)
	$Sprite2D.play("default")

func _physics_process(delta: float) -> void:
	if !returning:
		position += transform.x * speed
	else:
		position -= transform.x * speed


func _on_body_entered(body: Node2D) -> void:
	
	if self.is_in_group("friendly"):
		if body.is_in_group("enemy"):
			body.stun(0.5)
	else:
		if !body.is_in_group("enemy"):
			queue_free()
			pass


func _on_deletion_timer_timeout() -> void:
	queue_free()
	pass # Replace with function body.


func _on_return_timer_timeout() -> void:
	returning = true
	pass # Replace with function body.
