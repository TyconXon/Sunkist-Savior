extends "res://Scripts/adversary.gd"

@export var damage = 1.0
var move_turn = true

func _ready() -> void:
	$SpawnAnimation.play("spawn")

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

	if move_turn and target != null:
		move_to(playerReference.global_position, delta)
	else:
		freeze(delta)
	move_and_slide()
	manage_state()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("friendly") and body.is_in_group("character"):
		self.position #print(self.name + " is attacking " + body.name)
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
		health = 0
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


func _on_move_timer_timeout() -> void:
	$MoveTimer.start()
	move_turn = !move_turn
