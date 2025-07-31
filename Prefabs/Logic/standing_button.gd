extends Sprite2D

@export var pawExclusive = true
@export var nodraw = false
@export var triggerOnce = false
@export var thingToModify : Node
@export var propertiesToModify: Dictionary
@export var inclusiveActivatorFilter: Array[String]
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
	if inclusiveActivatorFilter.size() >= 1:
		for element in inclusiveActivatorFilter:
			if body.name.contains(element):
				print(name + " is filtering in " + body.name + " because it's named " + element)
				activated = !activated
				return
	elif body.name.contains("Paw") and pawExclusive:
		activated = !activated
		$AnimationPlayer.play("use")
		if triggerOnce:
			queue_free()
		
	elif !pawExclusive and body.is_in_group("bullet"):
		activated = !activated
		$AnimationPlayer.play("use")
		if triggerOnce:
			queue_free()
		
	print(name + " detected " + body.name)
	
		
