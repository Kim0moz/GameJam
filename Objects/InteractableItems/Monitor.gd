extends InteractableItem
class_name Monitor

@export var player : Player
var active : bool = false

func _ready():
	player.connect("computer_exit", Callable(self, "deactivate"))
	Activated.connect(activate)

func activate(mousePos = Vector2.ZERO):
	if active:
		return
	#super(mousePos)
	active = true
	player.startComputerState(global_position)

func deactivate():
	active = false
