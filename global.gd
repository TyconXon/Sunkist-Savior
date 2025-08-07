extends Node

var cameraZoom = Vector2(1,1)
var hudType = false
var speed = 400.0
var maxHealth = 5.0
var knifeCost = 1.0
var pawCooldown = 1.0
var onController = false
var hitstop_light: PointLight2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func hitstop(duration : float, color : Color):
	if hitstop_light == null: 
		hitstop_light = get_tree().get_first_node_in_group('hitstop')
	get_tree().get_first_node_in_group('hitstop').enabled = true
	get_tree().get_first_node_in_group('hitstop').color = color
	Engine.time_scale = 0
	await(get_tree().create_timer(duration, true, false, true).timeout)
	Engine.time_scale = 1
	get_tree().get_first_node_in_group('hitstop').enabled = false
