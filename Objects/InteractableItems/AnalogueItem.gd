extends InteractableItem
class_name AnalogueItem

var InputVector : Vector2 = Vector2.ZERO

func activate(mousePos = Vector2.ZERO):
	InputVector = Input.get_last_mouse_velocity().normalized()
	print(InputVector)
