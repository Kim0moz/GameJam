extends InteractableItem
class_name Monitor

@export var player : Player
var activated : bool = false

func activate(mousePos = Vector2.ZERO):
	if activated:
		return
	super(mousePos)
	activated = true
	player.setComputerState(global_position)