extends CharacterBody2D

@export var speed = 400.0
@export var max_health = 5.0
@export var push_force = 5.0

@export var friction = 600
@export var accel = 1500

var dead = false
var stunned = false


var health = max_health: 
	set(value):
		health = health_set(value)
	get:
		return health

func die():
	queue_free()

func health_set(value):
	if(value < health):
		$DamageAnimation.play("damaged")
		
	if(value <= 0 && !dead):
		die()
		return 0
	elif(value > max_health):
		return max_health
	else:
		return value


func handlePush():
	for id in get_slide_collision_count():
		var c = get_slide_collision(id)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)
		
