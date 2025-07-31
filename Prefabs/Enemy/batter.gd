extends "res://Scripts/adversary.gd"

@export var damage = 1.0

func _physics_process(delta: float) -> void:
	if stunned or dead:
		get_pushed(delta, 700)
		move_and_slide()
		return
	
	if attacking && attack_ready:
		target.health -= damage
		attack_ready = false
		self.position #print("ATTACK!")
		$HitTimer.start()

	if playerReference != null:
		move_to($NavigationAgent2D.get_next_path_position(), delta)
	else:
		freeze(delta)
	move_and_slide()
	handlePush()
	manage_state()


func make_path():
	$NavigationAgent2D.target_position = playerReference.position
 

func _on_nav_timer_timeout() -> void:
	if self is CharacterBody2D:
		#if can_see_player():
			make_path()





func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("friendly") and body.is_in_group("character") and start_awake:
		print(self.name + " is attacking " + body.name)
		target = body;
		awake = true
	pass # Replace with function body.

func manage_state():
	if velocity.x > 0:
		$Sprite2D.flip_h = true
	elif velocity.x < 0:
		$Sprite2D.flip_h = false
		
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
	attack_ready = true
	pass # Replace with function body.
	
