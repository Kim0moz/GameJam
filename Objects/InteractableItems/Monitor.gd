extends InteractableItem
class_name Monitor

@export var player : Player
var activated : bool = false

func _ready():
	player.connect("computer_exit", Callable(self, "deactivate"))

func activate(mousePos = Vector2.ZERO):
	if activated:
		return
	super(mousePos)
	activated = true
	player.setComputerState(global_position)

func deactivate():
	activated = false