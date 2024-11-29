extends InteractableItem

@export var player : Node3D
@export var ExitPoint : Node3D
@export var locked : bool = false


func move():
	if ExitPoint and locked == false:
		player.basis = ExitPoint.basis
		player.global_position = ExitPoint.global_position
		print("Moving from, ", self, "Moving to, ", ExitPoint)
		player.position.y += 1
