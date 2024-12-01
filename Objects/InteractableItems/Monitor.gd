extends InteractableItem
class_name Monitor

var active : bool = false

func _ready():
	GlobalVariables.player.connect("computer_exit", Callable(self, "deactivate"))
	Activated.connect(activate)

func activate(mousePos = Vector2.ZERO):
	if active:
		return
	#super(mousePos)
	active = true
	GlobalVariables.player.startComputerState(global_position)

func deactivate():
	active = false
