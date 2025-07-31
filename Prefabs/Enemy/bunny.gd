extends "res://Scripts/adversary.gd"

@export var rate = 0.25

func _physics_process(delta: float) -> void:
	
	if stunned:
		get_pushed(delta, 700)
		move_and_slide()
		return


	if awake:
		$RayCast2D.target_position = playerReference.position - position
		var colliding_with = $RayCast2D.get_collider()
		if (colliding_with == playerReference):
			target = playerReference	
			if attack_ready:
				shoot()
				attack_ready = false
				$HitTimer.start(rate)
				
	if target != null:
		move_to(playerReference.global_position, delta)
	else:
		freeze(delta)
				
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("friendly") and body.is_in_group("character") and start_awake:
		self.position #print(self.name + " is attacking " + body.name)
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


func _on_hitbox_area_exited(area: Area2D) -> void:
	if area.get_parent() == target: 
		attacking = false
	pass # Replace with function body.


func _on_stun_timer_timeout() -> void:
	stunned = false
	pass # Replace with function body.


func shoot():

	var instance = load("res://Prefabs/Bullet/knife.tscn").instantiate()
	instance.position = position
	instance.look_at(playerReference.position)
	instance.positionToAttack = playerReference.position
	get_parent().add_child(instance)
	
