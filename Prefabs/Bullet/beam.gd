extends Area2D

@onready var playerReference = get_tree().get_first_node_in_group("player")

@export var damage = 3.0
@export var followDuration = 3.0
@export var attackDelay = 1.0
@export var attackDuration = 1.0
var lockedin = true
var attacking = false
var hasAttacked = false

func _ready():
	$GenericTimer.start(followDuration)
	$CollisionShape2D.disabled = true

func _physics_process(delta: float) -> void:
	if lockedin:
		position = playerReference.position
		rotation += 90 * delta
	else:
		rotation += 180 * delta

func _on_deletion_timer_timeout() -> void:
	lockedin = false
	$AttackTimer.start(attackDelay)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("friendly"):
		if attacking:
			queue_free()
		

func _on_attack_timer_timeout() -> void:
	if attacking != true:
		attacking = true
		$AnimatedSprite2D.animation = "active"
		$AttackTimer.start(attackDuration)
		$CollisionShape2D.disabled = false
	else:
		queue_free()
	pass # Replace with function body.
