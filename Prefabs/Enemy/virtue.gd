extends "res://Scripts/adversary.gd"

@export var angerRate = 0.1
@export var delay = 8.0
@export var minDelay = 2.0

@export var damage = 3.0
@export var followTime = 3.0
@export var chargeTime = 1.0
@export var beamSustain = 1.5


func _start():
	$AnimatedSprite2D.play("default")

func _physics_process(delta: float) -> void:
	if stunned or dead:
		velocity = Vector2.ZERO
		attack_ready = false
		return
	
	if attack_ready:
		var instance = load("res://Prefabs/Bullet/beam.tscn").instantiate()
		instance.followDuration = followTime
		instance.attackDelay = chargeTime
		instance.scale *= scale
		instance.attackDuration = beamSustain
		instance.damage = damage
		get_parent().add_child(instance)

		if delay > minDelay:
			delay -= angerRate
			followTime -= angerRate * 2
			chargeTime -= angerRate
			beamSustain += angerRate

		attack_ready = false
		$HitTimer.start(delay)
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("friendly") and body.is_in_group("character") and start_awake:
		print(self.name + " is attacking " + body.name)
		target = body;
		awake = true
	pass # Replace with function body.

		
func _on_hitbox_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("friendly") and body.is_in_group("bullet"):
		health -= body.damage
	elif body.get_parent() == target: 
		attacking = true


func _on_hit_timer_timeout() -> void:
	attack_ready = true
	pass # Replace with function body.


func _on_stun_timer_timeout() -> void:
	stunned = false
	attack_ready = true
	pass # Replace with function body.
