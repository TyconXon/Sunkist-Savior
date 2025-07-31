extends Sprite2D

@export var playerExclusive = true
@export var nodraw = false
@export var triggerOnce = false
@export var thingToModify : Node
@export var propertiesToModify: Dictionary
@export var activatorFilter: Array[String]
var beforeProperties : Dictionary
var activator = null
var activated = false:
	set(value):
		activated = value
		if thingToModify == null:
			print(name + " wants to interact with something that doesn't exist!")
			return
		if activated:
			for element in propertiesToModify:
				thingToModify[element] = propertiesToModify[element]
		if !activated:
			for element in beforeProperties:
				thingToModify[element] = beforeProperties[element]

func _ready():
	visible = !nodraw
	for element in propertiesToModify:
		beforeProperties[element] = thingToModify[element]

func _on_area_2d_body_entered(body: Node2D) -> void:
	if activatorFilter.size() >= 1:
		for element in activatorFilter:
			if body.name.contains(element):
				print(name + " is filtering out " + body.name + " because it's named " + element)
				return
	if body.name == "Player" and playerExclusive:
		activated = true
		$AnimationPlayer.play("use")
		if triggerOnce:
			queue_free()
		
	elif !playerExclusive:
		if(activator == null):
			activator = body
		activated = true
		$AnimationPlayer.play("use")
		if triggerOnce:
			queue_free()
	print(name + " detected " + body.name)
	
		

func _on_area_2d_body_exited(body: Node2D) -> void:
	if triggerOnce:
		return
	if body.name == "Player" and playerExclusive:
		activated = false
		$AnimationPlayer.play("use")
		
	elif !playerExclusive and body == activator:
		print(name + " has lost contact with " + body.name)
		activated = false
		activator = null
		$AnimationPlayer.play("use")
		
		
