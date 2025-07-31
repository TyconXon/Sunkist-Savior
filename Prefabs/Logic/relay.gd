extends Sprite2D

@export var nodraw = false
@export var noline = false

@export var triggerOnce = false
@export var thingToModify : Node
@export var isNotImpulse = true
@export var propertiesToModify: Dictionary
@export var thingsToImpulse: Dictionary
#Things to impulse would be like [["path/to/Player", "kill"], ["path/to/Enemy", "revive"]] 
#OR it could be [["path/to/Player", ["heal", "40"]], ["path/to/Enemy", "revive"]]
var activated = false:
	set(value):
		if isNotImpulse:
			if thingToModify == null:
				print(name + " wants to interact with something that doesn't exist!")
				return
			activated = value
			
			if activated:
				for element in propertiesToModify:
					thingToModify[element] = propertiesToModify[element]
		else:
			for element in thingsToImpulse:
				if(get_node(element) == null):
					print("Missing " + str(element) + "!")
					continue
				if thingsToImpulse[element] is Dictionary:
					for keyANDValue in thingsToImpulse[element]:
						print("Calling " + str(element) + "'s " + str(keyANDValue) + " with the argument " + str(thingsToImpulse[element][keyANDValue]))
						get_node(element).call(keyANDValue, thingsToImpulse[element][keyANDValue])
				else:
					print("Calling "+ str(element) + "'s " + str(thingsToImpulse[element]))
					get_node(element).call(thingsToImpulse[element])

func _ready():
	visible = !nodraw
	$Line2D.visible = !noline

func activate() -> void:
		activated = !activated
		if triggerOnce:
			queue_free()
		print(name + "activated")
