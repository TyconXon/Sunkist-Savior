extends Sprite2D

#apple
@export_file var NEXT_SCENE = "res://Debug.tscn" 

func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body.name == "Player"):
		print("==============================")
		print("Time: " + str(Global.time))
		print("Style: " + str(Global.stylePoints))
		print("Knifes: " + str(Global.usedKnifes) + " / " + str(Global.knifesObtained) + "( " + str(Global.usedKnifes/Global.knifesObtained)+ " )")
		print("Hits: " + str(Global.hitsTaken))
		print("Killed: " + str(Global.killed) + " / " + str(Global.enemies))
		print("Cheated: " + str(Global.cheated))
		print("==============================")
		
		Global.hitstop(3,Color.WHITE)
		get_tree().change_scene_to_file(NEXT_SCENE)
	pass # Replace with function body.
