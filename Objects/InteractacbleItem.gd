extends Node3D
class_name InteractableItem

signal activated

func _enter_tree() -> void:
	add_to_group("InteractableItems")
	

func activate(mousePos  = Vector2.ZERO):
	#Handle Activation Scripts here
	activated.emit()
	print(name, " activated")
