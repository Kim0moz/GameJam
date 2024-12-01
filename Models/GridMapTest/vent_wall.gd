extends InteractableItem

var player : Node3D
@export var ExitPoint : Node3D
@export var locked : bool = false

func _ready() -> void:
	await GlobalVariables.playerReady
	player = GlobalVariables.player
	GlobalVariables.screwDriverGet.connect(unlock)

func move():
	if ExitPoint and locked == false:
		player = GlobalVariables.player
		player.basis = ExitPoint.basis
		player.global_position = ExitPoint.global_position
		print("Moving from, ", self, "Moving to, ", ExitPoint)
		player.position.y += 1
		
func displayText():
	if locked==true:
		InfoPopUp.Text = "Locked"
	else:
		InfoPopUp.Text = ExitPoint.name

func hidePopUp():
	InfoPopUp.HideText()
	
func unlock(val):
	if val == true:
		locked = false
	else:
		locked = true
