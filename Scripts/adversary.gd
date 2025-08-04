extends "res://Scripts/character.gd"

@export var show_health = false
@export var wake_on_hurt = true
@export var allow_random_drops = true
@export var start_awake = true
@export_file var loot
@export var lootProperties: Dictionary 

var awake = false

var target = null
var attack_ready = true
var attacking = false

var idoled = false:
	set(value):
		idoled = value
		health_set(9999)


@onready var playerReference = get_tree().get_first_node_in_group("player")

func _ready():
	health = max_health
	if show_health:
		$Health.show()
		$Health.text = str(health)
	$ProgressBar.value = health
	$ProgressBar.max_value = max_health

func health_set(value):
	
	if($ProgressBar.value):
		$ProgressBar.value = health
		$ProgressBar.max_value = max_health
		
	
	if !idoled:
		$Health.text = str(health)
	else:
		$Health.text = "IDOLED"
		return max_health
		
	if(value < health):
		$DamageAnimation.stop()
		$DamageAnimation.play("damaged")
		if $Blood:
			var miniblood = $Blood.duplicate()
			add_child(miniblood)
			
			miniblood.scale_amount_max = 1.0
			miniblood.restart()
		
		if(wake_on_hurt):
			awake = true
		
	if(value <= 0):
		die()
		return 0
	elif(value > max_health):
		return max_health
	else:
		return value

func handle_drops():
	$Health.hide()
	$ProgressBar.hide()
	if allow_random_drops == true:
		var rng = randi() % 3
		if rng == 1:
			var inst = load("res://Prefabs/PickUp/health_potion.tscn").instantiate()
			inst.position = global_position
			get_parent().add_child(inst)
		elif rng == 2:
			var inst = load("res://Prefabs/PickUp/knifepack.tscn").instantiate()
			inst.position = global_position
			get_parent().add_child(inst)
	if loot != "<null>" and loot != null:
		
		var inst = load(loot).instantiate()
		inst.position = global_position
		
		if lootProperties != null:
			for element in lootProperties:
				inst[element] = lootProperties[element]
				
		get_parent().add_child(inst)

func die():
	handle_drops()
	dead = true
	if $Blood:
		$Blood.isDead = true
		$Blood.scale_amount_max = 5.0
		$Blood.restart()
		$Blood.reparent(get_parent(), true)
	queue_free()

var stunPower = 1

func stun(time, POWER):
	stunned = true
	$StunTimer.start(time)
	pass
	
func freeze(delta):
	if velocity.length() > (friction * delta):
		velocity -= velocity.normalized() * (friction * delta)
	else:
		velocity = Vector2.ZERO

func move_to(pos, delta):
	var input_direction = global_position.direction_to(pos)
	velocity += input_direction * accel * delta
	velocity = velocity.limit_length(speed)

func move_in_direction(dir, nSpeed, delta):
	velocity += dir * accel * delta
	velocity = velocity.limit_length(nSpeed)
	
func can_see_player():
	$ProgressBar.value = health
	$ProgressBar.max_value = max_health
	
	if awake and playerReference != null:
		$RayCast2D.target_position = playerReference.position - position
		var colliding_with = $RayCast2D.get_collider()
		if (colliding_with == playerReference):
			return true
		else:
			return false

func get_pushed(delta, nSpeed, dir = playerReference.global_position):
	#move_in_direction(global_position.direction_to(dir) * -1, nSpeed, delta)
	velocity = Vector2.ZERO
	velocity += (-1 * global_position.direction_to(dir) ) * accel * delta * stunPower
