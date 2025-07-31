extends Sprite2D

@export var thingToModify : Node
@export var impossiblyLargeNumber = 9999999
var beforeHealth : float
var beforeMod 

func _ready():
	beforeHealth = thingToModify.max_health
	thingToModify.idoled = true
	#beforeMod = thingToModify.modulate
	#thingToModify.modulate = Vector3(0,255,255)
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name.contains("Paw"):
		thingToModify.idoled = false
		thingToModify.max_health = beforeHealth
		thingToModify.health = beforeHealth
		#thingToModify.modulate = beforeMod
		queue_free()
