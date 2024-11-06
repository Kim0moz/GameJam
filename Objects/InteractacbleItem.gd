extends Node3D
class_name InteractableItem


func _enter_tree() -> void:
	add_to_group("InteractableItems")
	

func activate():
	#Handle Activation Scripts here
	pass
