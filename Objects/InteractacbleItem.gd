extends Node3D
class_name InteractableItem

signal Activated
signal Hovered
signal Exit

func _enter_tree() -> void:
	add_to_group("InteractableItems")
	

func activate(mousePos  = Vector2.ZERO):
	#Handle Activation Scripts here
	Activated.emit()
	print(name, " activated")
