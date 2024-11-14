extends Node3D

@export var Exit : Node3D
@export var ExitPoint : Node3D

@export var player : Node3D


func move():
	player.basis = Exit.basis
	player.global_position = Exit.global_position
	print("Moving from, ", self, "Moving to, ", Exit)
	player.position.y += 1
