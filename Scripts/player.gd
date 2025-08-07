extends "res://Scripts/character.gd"

var knife_tscn = preload("res://Prefabs/Bullet/knife.tscn")
var claw_tscn = preload("res://Prefabs/Bullet/paw.tscn")
var boomerang_tscn = preload("res://Prefabs/Bullet/boomerang.tscn")


var zoomStep = 0.25
var hudZoomStep = 2

@export var ammo = 10
@export var keys = 0

@export var sprintSpeedMultiplier = 1.5
@export var sprintStaminaCostPerSecond = 0.5
@export var sprintStaminaRegenPerSecond = 0.14
@export var sprintStaminaRecoveryTime = 2.5



var isSprinting = false
var staminaRecovery = false

var hudOnSprite = false
var paw_ready = true

var stamina = 1:
	set(value):
		stamina = staminaEvaluation(value)
		#$Camera2D/STAMINA.value = stamina
		

func staminaEvaluation(value):
	return clampf(value, 0, 1)

func die():
	$DeathTimer.start()
	$Camera2D/PauseController/Death.visible = true
	$Camera2D/PauseController/Death.reparent(get_parent())
	hide()
	dead = true

func _on_death_timer_timeout() -> void:
	get_tree().reload_current_scene()




func _ready():
	$Camera2D.zoom = Global.cameraZoom
	$CursorHUD.scale = Vector2.ONE / $Camera2D.zoom
	hudOnSprite = Global.hudType
	$StaminaRecoveryTimer.wait_time = sprintStaminaRecoveryTime
	changeZoom(0)


func _physics_process(delta):
	if dead: 
		velocity = Vector2.ZERO
		return
	
	var lerch_strength = 10
	var new_position = get_local_mouse_position() * lerch_strength
	$Camera2D.global_position = lerp(global_position, new_position, delta)
	
	if Input.is_action_pressed("sprint") and stamina > 0.001:
			$StaminaRecoveryTimer.stop()
			stamina -= sprintStaminaCostPerSecond * delta
			isSprinting = true
			staminaRecovery = false
	else:
		isSprinting = false
			
	if stamina < 1 and $StaminaRecoveryTimer.is_stopped():
		$StaminaRecoveryTimer.start()
	
	if staminaRecovery:
		stamina += sprintStaminaRegenPerSecond * delta
	var speedMult = 1.0
		
	if isSprinting:
		speedMult = sprintSpeedMultiplier
		
	var input_direction = Input.get_vector("left", "right", "up", "down")
	if input_direction == Vector2.ZERO:
		if velocity.length() > (friction * delta):
			velocity -= velocity.normalized() * (friction * delta)
		else:
			velocity = Vector2.ZERO
	else:
		velocity += input_direction * accel * delta
		velocity = velocity.limit_length(speed * speedMult)

	
	move_and_slide()
	handlePush()

func _process(delta):
	if(!hudOnSprite):
		$CursorHUD.position = get_local_mouse_position()
	$CursorHUD/HPBAR.value = health
	$CursorHUD/HPBAR.max_value = max_health
	
	$CursorHUD/AMMO.text = "PK: " + str(ammo)
	$CursorHUD/KEYS.text = "KE: " + str(keys)
	#$Camera2D/HP.text = "HP: " + str(health) + " / " + str(max_health)
	
func changeZoom(direction):
	$Camera2D.zoom += direction * Vector2(0.25, 0.25)
	$CursorHUD.scale = Vector2.ONE / $Camera2D.zoom
	$Camera2D/PauseController.scale = Vector2.ONE / $Camera2D.zoom
	$Camera2D/PauseController/Death.scale = Vector2.ONE / $Camera2D.zoom
	#$Camera2D/HP.scale = Vector2.ONE / $Camera2D.zoom
	
	
	Global.cameraZoom = $Camera2D.zoom
	
func _input(event):
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()
		
	if dead: 
		velocity = Vector2.ZERO
		return
		
	if(event is InputEventKey):
		Global.onController = false
		pass
	elif(event is InputEventJoypadButton):
		Global.onController = true
		pass
		
	if event.is_action_pressed("shoot"):
		shoot()
	if event.is_action_pressed("paw"):
		claw()
	if event.is_action_pressed("boomerang"):
		Global.hitstop(2)
		pass
	if event.is_action_pressed("edit"):
		edit()
	
	if event.is_action_pressed("toggle hud"):
		hudOnSprite = !hudOnSprite
		$CursorHUD.position = Vector2(0, 0)
		Global.hudType = hudOnSprite
		
	if event.is_action_pressed("zoom in"):
		changeZoom(1)
	elif event.is_action_pressed("zoom out"):
		changeZoom(-1)
		

func claw():
	if !paw_ready:
		return
	var instance = claw_tscn.instantiate()
	#instance.position = position
	instance.look_at(get_local_mouse_position())
	instance.add_to_group("friendly")

	add_child(instance)
	
	paw_ready = false
	$PawCooldown.start()
	
func edit():
	var tilemap:TileMapLayer = get_tree().get_first_node_in_group("tilemap")
	var mapPos = tilemap.local_to_map(tilemap.get_local_mouse_position())
	if (tilemap.get_cell_atlas_coords(mapPos) == Vector2i(24,0)):
		tilemap.set_cell(mapPos, 0, Vector2i(28,14))
	else:
		tilemap.set_cell(mapPos, 0, Vector2i(24,0))
		
	
func boomerang():
	if !paw_ready:
		return
	var instance = boomerang_tscn.instantiate()
	#instance.position = position
	instance.look_at(get_local_mouse_position())
	instance.add_to_group("friendly")
	add_child(instance)
	
	paw_ready = false
	$PawCooldown.start()


func shoot():
	if ammo <= 0:
		return
		
	var instance = knife_tscn.instantiate()
	instance.position = position
	instance.look_at(get_global_mouse_position())
	instance.add_to_group("friendly")
	get_parent().add_child(instance)
	
	ammo -= 1


func _on_paw_cooldown_timeout() -> void:
	paw_ready = true
	pass # Replace with function body.


func _on_hitbox_body_entered(body: Node2D) -> void:
	if !body.is_in_group("friendly") and body.is_in_group("bullet"):
		health -= body.damage


func _on_stamina_recovery_timer_timeout() -> void:
	staminaRecovery = true
