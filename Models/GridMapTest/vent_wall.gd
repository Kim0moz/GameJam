extends Node3D

@export var exit : Node3D
@export var ExitPoint : Node3D

@export var player : Node3D


func move():
	player.basis = exit.basis
	player.position.y += 1
