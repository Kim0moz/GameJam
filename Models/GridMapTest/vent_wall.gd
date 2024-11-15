extends InteractableItem

@export var Data : Dictionary = {
	"Exit" : "",
}
@export var player : Node3D
@export var	ExitPoint : Node3D


func move():
	player.basis = get_node(Data.Exit).basis
	player.global_position = get_node(Data.Exit).global_position
	print("Moving from, ", self, "Moving to, ", Data.Exit)
	player.position.y += 1
